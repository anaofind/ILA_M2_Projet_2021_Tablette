import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';


class Intervention {
  final String id;
  final String nom;
  final String adresse;
  final String codeSinistre;
  final DateTime date;
  List<MoyenIntervention> moyens;

  Intervention(this.id, this.nom, this.adresse, this.codeSinistre, this.date, this.moyens);

  List<Map> ConvertMoyensToMap(List<MoyenIntervention> moyens) {
    List<Map> moyensIntervention = [];
    moyens.forEach((MoyenIntervention moyen) {
      Map step = moyen.toMap();
      moyensIntervention.add(step);
    });
    return moyensIntervention;
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'adresse': adresse,
      'codeSinistre': codeSinistre,
      'date': date,
      'moyens': ConvertMoyensToMap(moyens),
    };
  }

  Intervention.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        nom = snapshot.data()['nom'],
        adresse = snapshot.data()['adresse'],
        codeSinistre = snapshot.data()['codeSinistre'],
        date = snapshot.data()['date'].toDate(),
        moyens =new List<MoyenIntervention>.from(snapshot.data()['moyens'].map((s) => MoyenIntervention.fromMap(s)).toList());

}
