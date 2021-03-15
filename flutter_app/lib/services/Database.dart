import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/UserData.dart';

class Database{
  final CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<void> uploadUser(String email, String login, String name, String firstName, String userID){
    return users.add({
      'email' : email,
      'login' : login,
      'name' : name,
      'firstName' : firstName,
      'userID' : userID
    }).then((value) => print("user added")).catchError((error) => print("error during upload " + error.code));
  }

  Future<QueryDocumentSnapshot> getFirstDoc(Query query) async {
    QuerySnapshot snapshot = await query.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    if (docs.length > 0) {
      QueryDocumentSnapshot doc = snapshot.docs.first;
      return doc;
    }
  }

  Future<List<QueryDocumentSnapshot>> getListDocs(Query query) async {
    QuerySnapshot snapshot = await query.get();
    List<QueryDocumentSnapshot> docs = snapshot.docs;
    return docs;
  }

  Stream<DocumentSnapshot> findUserInfoByUID(String userID){
    return users.doc(userID).snapshots();
  }

  Future<UserData> loadUserInfoByLogin(String login) async{
    Query query = users.where('login', isEqualTo: login).limit(1);
    QueryDocumentSnapshot doc = await getFirstDoc(query);
    if (doc != null) {
      if (doc.exists) {
        UserData user = UserData(
          email: doc.data()['email'],
          login: doc.data()['login'],
          name: doc.data()['name'],
          firstName: doc.data()['firstName'],
        );
        return user;
      }
    }
  }

  Future<UserData> loadUserInfoByEmail(String email) async{
    Query query = users.where('email', isEqualTo: email).limit(1);
    QueryDocumentSnapshot doc = await getFirstDoc(query);
    if (doc != null) {
      if (doc.exists) {
        UserData user = UserData(
          email: doc.data()['email'],
          login: doc.data()['login'],
          name: doc.data()['name'],
          firstName: doc.data()['firstName'],
        );
        return user;
      }
    }
  }

  Future<UserData> loadUserInfoById(String userId) async{
    Query query = users.where('userID', isEqualTo: userId).limit(1);
    QueryDocumentSnapshot doc = await getFirstDoc(query);
    if (doc != null) {
      if (doc.exists) {
        UserData user = UserData(
          email: doc.data()['email'],
          login: doc.data()['login'],
          name: doc.data()['name'],
          firstName: doc.data()['firstName'],
        );
        return user;
      }
    }
  }

}