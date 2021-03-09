import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> uploadUser(String name, String firstName, String userID){
    return users.add({
      'name' : name,
      'firstName' : firstName,
      'userID' : userID
    }).then((value) => print("user added")).catchError((error) => print("error during upload " + error));
  }

  Stream<DocumentSnapshot> findUserInfoByUID(String userID){
    return users.doc(userID).snapshots();
  }

  Stream<QuerySnapshot> loadUserInfo(String userID) {
    return users
        .where('userID', isEqualTo: userID)
        .snapshots();
  }
}