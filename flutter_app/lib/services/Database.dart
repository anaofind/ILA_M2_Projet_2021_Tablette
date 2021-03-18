import 'package:cloud_firestore/cloud_firestore.dart';

class Database{

  Future<DocumentSnapshot> getFirstDoc(Query query) async {
    QuerySnapshot snapshot = await query.get();
    List<DocumentSnapshot> docs = snapshot.docs;
    if (docs.length > 0) {
      DocumentSnapshot doc = snapshot.docs.first;
      return doc;
    }
  }

  Future<List<DocumentSnapshot>> getListDocs(Query query) async {
    QuerySnapshot snapshot = await query.get();
    List<DocumentSnapshot> docs = snapshot.docs;
    return docs;
  }
}