import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/models/MoyenIntervention.dart';

import 'SymbolIntervention.dart';


class Intervention {
  final String id;
  final String nom;
  final String adresse;
  final String codeSinistre;
  final DateTime date;
  List<MoyenIntervention> moyens;
  List<SymbolIntervention> symbols;
  List<String> missions;

  Intervention(this.id, this.nom, this.adresse, this.codeSinistre, this.date, this.moyens): symbols = List(), missions = List();

  List<Map> ConvertMoyensToMap(List<MoyenIntervention> moyens) {
    List<Map> moyensIntervention = [];
    moyens.forEach((MoyenIntervention moyen) {
      Map step = moyen.toMap();
      moyensIntervention.add(step);
    });
    return moyensIntervention;
  }
  List<Map> ConvertSymbolsToMap(List<SymbolIntervention> symbols) {
    List<Map> symbolsIntervention = [];
    symbols.forEach((SymbolIntervention symbol) {
      Map step = symbol.toMap();
      symbolsIntervention.add(step);
    });
    return symbolsIntervention;
  }
  List<Map> ConvertMissionsToMap(List<String> missions) {
    List<Map> missionsIntervention = [];
    missions.forEach((String idMission) {
      Map step = {'id' : idMission};
      missionsIntervention.add(step);
    });
    return missionsIntervention;
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'adresse': adresse,
      'codeSinistre': codeSinistre,
      'date': date,
      'moyens': ConvertMoyensToMap(moyens),
      'symbols': ConvertSymbolsToMap(symbols),
      'missions': ConvertMissionsToMap(missions)
    };
  }

  Intervention.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        nom = snapshot.data()['nom'],
        adresse = snapshot.data()['adresse'],
        codeSinistre = snapshot.data()['codeSinistre'],
        date = snapshot.data()['date'].toDate(),
        moyens =new List<MoyenIntervention>.from(snapshot.data()['moyens'].map((s) => MoyenIntervention.fromMap(s)).toList()),
        symbols =new List<SymbolIntervention>.from(snapshot.data()['symbols'].map((s) => SymbolIntervention.fromMap(s)).toList()),
        missions = (snapshot.data()['missions'] != null)? new List<String>.from(snapshot.data()['missions'].map((s) => s['id']).toList()): [];


  String get getNom {
    return this.nom;
  }

  String get getCode {
    return this.codeSinistre;
  }

  String get getAdresse {
    return this.adresse;
  }

  DateTime get getDate {
    return this.date;
  }

  List<MoyenIntervention> get getMoyens{
    return this.moyens;
  }

  List<String> get getMissions{
    return this.missions;
  }

}
