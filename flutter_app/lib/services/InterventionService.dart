
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Moyen.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';

class InterventionService {
  CollectionReference interventions = FirebaseFirestore.instance.collection('interventions');

  Future<void> addIntervention(String nom, String adresse, String codeSinistre, List<MoyenIntervention> moyens) {
    DateTime date = DateTime.now();
    /*List<MoyenIntervention> moyensIntervention = List<MoyenIntervention>();
    moyens.forEach((moyen) {
      moyensIntervention.add(new MoyenIntervention(moyen, Etat.enCours.toString(), date, null, null));
    });*/
    moyens.forEach((moyen) {
     moyen.demandeA = date;
      });
    Intervention intervention = Intervention(null, nom, adresse, codeSinistre, date, moyens);
    return  interventions.add(intervention.toMap());
  }
  Stream<QuerySnapshot> loadAllInterventions(){
    return interventions.snapshots();

  }
  /*
  Future<List<String>> loadAllSinistres() async{
    QuerySnapshot snapshots = await sinistres.get();

    return snapshots.docs.map((doc) => doc.data()['codeSinistre'])
    .toList();

  }
*/
  Future<DocumentSnapshot> getInterventionById(String id) {

    return interventions.doc(id).get();

  }

  Future<DocumentSnapshot> getInterventionByName(String nom) {

    return  interventions.where(
        "nom", isEqualTo: nom)
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
