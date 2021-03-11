import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> uploadUser(String email, String login, String name, String firstName, String userID){
    return users.add({
      'email' : email,
      'login' : login,
      'name' : name,
      'firstName' : firstName,
      'userID' : userID
    }).then((value) => print("user added")).catchError((error) => print("error during upload " + error));
  }

  Stream<DocumentSnapshot> findUserInfoByUID(String userID){
    return users.doc(userID).snapshots();
  }

  Stream<QuerySnapshot> loadUserInfoByLogin(String login){
    return users
        .where('login', isEqualTo: login)
        .snapshots();
  }

  Stream<QuerySnapshot> loadUserInfoByEmail(String email){
    return users
        .where('email', isEqualTo: email)
        .snapshots();
  }

  Stream<QuerySnapshot> loadUserInfo(String userID) {
    return users
        .where('userID', isEqualTo: userID)
        .snapshots();
  }
}