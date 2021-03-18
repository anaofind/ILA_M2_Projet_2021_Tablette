import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Moyen.dart';

class MoyenService {
  CollectionReference moyens = FirebaseFirestore.instance.collection('moyens');

  Future<void> addMoyen(String codeMoyen, String description, String couleurDefaut) {
    Moyen moyen = Moyen(null, codeMoyen, description, couleurDefaut);
    return  moyens.add(moyen.toMap());
  }
  Stream<QuerySnapshot> loadAllMoyens(){
    return moyens.snapshots();

  }
  /*
  Future<List<String>> loadAllSinistres() async{
    QuerySnapshot snapshots = await sinistres.get();
    return snapshots.docs.map((doc) => doc.data()['codeSinistre'])
    .toList();
  }
*/
  Future<DocumentSnapshot> getMoyenById(String id) {

    return moyens.doc(id).get();

  }

  Stream<QuerySnapshot> getMoyenByCode(String codeMoyen) {

    return  moyens.where(
        "codeMoyen", isEqualTo: codeMoyen).snapshots();


  }

}