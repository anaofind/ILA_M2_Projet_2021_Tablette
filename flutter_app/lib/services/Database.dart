import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

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
}