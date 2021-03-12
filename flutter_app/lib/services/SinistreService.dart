
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Sinistre.dart';

class SinistreService {
  CollectionReference sinistres = FirebaseFirestore.instance.collection('sinistres');

  Future<void> addSinistre(String codeSinistre, String description) {
    Sinistre sinistre = Sinistre(null, codeSinistre, description);
    return  sinistres.add(sinistre.toMap());
  }
  Stream<QuerySnapshot> loadAllSinistres(){
    return sinistres.snapshots();

  }
  /*
  Future<List<String>> loadAllSinistres() async{
    QuerySnapshot snapshots = await sinistres.get();

    return snapshots.docs.map((doc) => doc.data()['codeSinistre'])
    .toList();

  }
*/
  Future<DocumentSnapshot> getSinistreById(String id) {

    return sinistres.doc(id).get();

  }

  Future<DocumentSnapshot> getSinistreByCode(String codeSinistre) {

    return  sinistres.where(
        "codeSinistre", isEqualTo: codeSinistre)
        .get()
        .then((querySnapshot) {
      if(querySnapshot.size!=0) {
        return querySnapshot.docs[0];
      }
      else{
        return null;
      }
    });

  }

}
