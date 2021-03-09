import 'package:firebase_auth/firebase_auth.dart';

import 'Database.dart';


class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Database database = Database();

  Database getDatabase(){
    return database;
  }

  Stream<User> get user {
    return auth.authStateChanges();
  }

  Future<void> createAccount(
      String email, String password, String nom, String prenom) async {
    String errorMessage;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      database.uploadUser(nom, prenom, userCredential.user.uid);
    } catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          errorMessage = "This email is already is use.";
          break;
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "weak-password":
          errorMessage = "Please choose a stronger password.";
          break;
        default:
          errorMessage = "An undefined error happened.";
      }
      if (errorMessage != null) {
        return Future.error(error.code + ":" + errorMessage);
      }
    }
    await signInAccount(email, password);
  }

  Future<void> signInAccount(String email, String password) async {
    String errorMessage;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        default:
          errorMessage = "An undefined error happened.";
      }
      errorMessage = error.code;
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (error) {
      return Future.error("Unexpected log out error");
    }
  }
}