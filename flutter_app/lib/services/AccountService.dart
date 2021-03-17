import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/models/Role.dart';
import 'package:flutter_app/models/UserData.dart';

import '../models/UserData.dart';
import 'Database.dart';

class AccountService {
  static CollectionReference users = FirebaseFirestore.instance.collection("users");

  static FirebaseAuth auth = FirebaseAuth.instance;
  static Database database = Database();

  static Stream<User> get user {
    return auth.authStateChanges();
  }

  static Future<void> uploadUser(String email, String login, String name, String firstName, String userID){
    return users.add({
      'email' : email,
      'login' : login,
      'name' : name,
      'firstName' : firstName,
      'userID' : userID,
      'role' : Role.Intervener.toString()
    }).then((value) => print("user added")).catchError((error) => print("error during upload " + error.code));
  }

  static Future<UserData> loadUserInfoByLogin(String login) async{
    Query query = users.where('login', isEqualTo: login).limit(1);
    QueryDocumentSnapshot doc = await database.getFirstDoc(query);
    if (doc != null) {
      if (doc.exists) {
        return UserData.fromSnapshot(doc);
      }
    }
  }

  static Future<UserData> loadUserInfoByEmail(String email) async{
    Query query = users.where('email', isEqualTo: email).limit(1);
    QueryDocumentSnapshot doc = await database.getFirstDoc(query);
    if (doc != null) {
      if (doc.exists) {
        return UserData.fromSnapshot(doc);
      }
    }
  }

  static Future<DocumentSnapshot> loadUserInfoById(String userID) async{
    Query query = users.where('userID', isEqualTo: userID).limit(1);
    QueryDocumentSnapshot doc = await database.getFirstDoc(query);
    return doc;
  }

  static Stream<QuerySnapshot> loadUserInfo(String userID) {
    return users
        .where('userID', isEqualTo: userID)
        .snapshots();
  }

  static Stream<QuerySnapshot> loadCurrentUser() {
    if (auth.currentUser != null) {
      return loadUserInfo(auth.currentUser.uid);
    }
  }

  static Future<void> updateUser(UserData userData) async {
    QuerySnapshot snapshot = await loadCurrentUser().first;
    DocumentReference reference = users.doc(snapshot.docs[0].id);
    reference.set(userData.toMap());
  }

  static Future<void> updateRoleUser(Role role) async {
    if (auth.currentUser != null) {
      QuerySnapshot snapshot = await loadCurrentUser().first;
      UserData userData = UserData.fromSnapshot(snapshot.docs[0]);
      if (userData != null) {
       userData.role = role;
       updateUser(userData);
      }
    }
  }


  Future<String> signUp(String email, String login, String password, String name, String firstName) async {
    String errorMessage;

    UserData userData = await loadUserInfoByLogin(login);
    if (userData != null) {
      errorMessage = "login already used";
    }

    if (errorMessage == null) {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await uploadUser(email, login, name, firstName, userCredential.user.uid);
      } catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            errorMessage = "This email is already is use";
            break;
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed";
            break;
          case "weak-password":
            errorMessage = "Please choose a stronger password";
            break;
          default:
            errorMessage = "An undefined error happened";
        }
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }
    return await signOut();
  }

  Future<String> signIn(String email, String password, Role role) async {
    String errorMessage;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      updateRoleUser(role);
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist";
          break;
        default:
          errorMessage = error.code;
      }
    }
    return errorMessage;
  }

  Future<String> signInWithLogin(String login, String password, Role role) async {
    String errorMessage;
    UserData userData = await loadUserInfoByLogin(login);
    if (userData != null) {
      errorMessage = await signIn(userData.email, password, role);
    } else {
      errorMessage = "login not found";
    }
    return errorMessage;
  }

  Future<String> signOut() async {
    String errorMessage;
    try {
      await auth.signOut();
    } catch (error) {
      errorMessage = "Unexpected log out error";
    }
    return errorMessage;
  }
}