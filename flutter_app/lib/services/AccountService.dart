import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/model/Role.dart';
import 'package:flutter_app/model/UserData.dart';

import '../model/UserData.dart';
import 'Database.dart';

class AccountService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Database database = Database();
  static UserData currentUserData;

  static Role futureRole;

  static Database getDatabase(){
      return database;
  }

  static Stream<User> get user {
    return auth.authStateChanges();
  }

  static Future<void> refreshCurrentUser(String email) async {
    QuerySnapshot query = await database.loadUserInfoByEmail(email).first;
    if (query != null) {
      if (query.docs.length > 0) {
        QueryDocumentSnapshot doc = query.docs.first;
        if (doc.exists) {
          print("CREATE USER");
          currentUserData = UserData(
              email: doc.data()['email'],
              login: doc.data()['login'],
              name: doc.data()['name'],
              firstName: doc.data()['firstName'],
              role: futureRole
          );
        }
      }
    }
  }

  static bool isSignIn() {
    return currentUserData != null;
  }

  static Future<String> signUp(String email, String login, String password, String nom, String prenom) async {
    String errorMessage;
    QuerySnapshot query = await database.loadUserInfoByLogin(login).first;
    if (query != null) {
      QueryDocumentSnapshot doc = query.docs.first;
      if (doc != null && doc.exists) {
        errorMessage = "login already used";
      }
    } else {
      errorMessage = "error query";
    }
    if (errorMessage == null) {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        database.uploadUser(email, login, nom, prenom, userCredential.user.uid);
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

  static Future<String> signIn(String email, String password, Role role) async {
    String errorMessage;
    try {
      futureRole = role;
      refreshCurrentUser(email);
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      futureRole = null;
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

  static Future<String> signInWithLogin(String login, String password, Role role) async {
    String errorMessage;
    QuerySnapshot query = await database.loadUserInfoByLogin(login).first;
    if (query != null) {
      QueryDocumentSnapshot doc = query.docs.first;
      if (doc != null) {
        String email = doc.data()['email'];
        print(doc.data().toString());
        errorMessage = await signIn(email, password, role);
      } else {
        errorMessage = "login not found";
      }
    } else {
      errorMessage = "error query";
    }
    return errorMessage;
  }

  static Future<String> signOut() async {
    String errorMessage;
    try {
      await auth.signOut();
      currentUserData = null;
    } catch (error) {
      errorMessage = "Unexpected log out error";
    }
    return errorMessage;
  }
}