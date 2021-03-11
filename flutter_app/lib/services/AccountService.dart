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

  static Future<void> refreshCurrentUser(String email, Role role) async {
    currentUserData = await database.loadUserInfoByEmail(email);
    currentUserData.role = role;
  }

  static bool isSignIn() {
    return currentUserData != null;
  }

  static Future<String> signUp(String email, String login, String password, String name, String firstName) async {
    String errorMessage;

    UserData userData = await database.loadUserInfoByLogin(login);
    if (userData != null) {
      errorMessage = "login already used";
    }

    if (errorMessage == null) {
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
        await database.uploadUser(email, login, name, firstName, userCredential.user.uid);
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
      refreshCurrentUser(email, role);
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
    UserData userData = await database.loadUserInfoByLogin(login);
    if (userData != null) {
      errorMessage = await signIn(userData.email, password, role);
    } else {
      errorMessage = "login not found";
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