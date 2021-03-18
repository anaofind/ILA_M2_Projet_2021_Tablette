import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/services/MoyenService.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_app/util/ColorConverter.dart';

import 'Moyen.dart';
import 'SymbolIntervention.dart';

class MoyenInterventionDocument {
  List<MoyenIntervention> moyensIntervention;
}

class MoyenIntervention {
  Moyen moyen;
  String id;
  String etat;
  DateTime demandeA;
  DateTime departA;
  DateTime arriveA;
  Color couleur;
  Position position;
  String basePath;

  MoyenIntervention(this.moyen, this.etat, this.demandeA, this.departA, this.arriveA, this.couleur, this.basePath):id = Uuid().v4(), position = null;


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codeMoyen': moyen.codeMoyen,
      'description': moyen.description,
      'couleurDefaut': moyen.couleurDefaut,
      'etat': etat,
      'demandeA': demandeA,
      'departA': departA,
      'arriveA': arriveA,
      'couleur': ColorConverter.stringFromColor(couleur),
      'latitude': position!=null?position.latitude:null,
      'longitude': position!=null?position.longitude:null,
      'basePath': basePath,
    };
  }
  MoyenIntervention.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        moyen = Moyen(null, map['codeMoyen'], map['description'], map['couleurDefaut']),
        id = map['id'],
        etat = map['etat'],
        demandeA = map['demandeA'].toDate(),
        departA = map['departA']!=null?map['departA'].toDate():null,
        arriveA = map['arriveA']!=null?map['arriveA'].toDate():null,
        couleur = ColorConverter.colorFromString(map['couleur']),
        position = Position( map['latitude'], map['longitude']),
        basePath = map['basePath'];

  MoyenIntervention.fromCaracteristicsAndPosition(SymbolCaracteristics caracteristics, Position position)  {
    MoyenService moyenService = MoyenService();
    /*moyenService.getMoyenByCode(caracteristics.nomSymbol)
        .then((snapshot) {
          print('code ' + snapshot.data()['codeMoyen']);
          print('description ' + snapshot.data()['description']);
          print('couleurDefaut ' + snapshot.data()['couleurDefaut']);

      this.id = Uuid().v4();
      this.moyen =  Moyen.fromSnapshot(snapshot);
      this.position =position;
      this.couleur =ColorConverter.colorFromString(caracteristics.couleur);
      this.etat = SymbolIntervention.EtatFromCode(caracteristics.etat);
      this.basePath =caracteristics.basePath;
      demandeA = DateTime.now();
      departA = null;
      arriveA = null;
        }
    );*/
    moyenService.getMoyenByCode(caracteristics.nomSymbol).forEach((element) {
      this.id = Uuid().v4();
      this.moyen =  Moyen.fromSnapshot(element.docs[0]);
      this.position =position;
      this.couleur =ColorConverter.colorFromString(caracteristics.couleur);
      this.etat = SymbolIntervention.EtatFromCode(caracteristics.etat);
      this.basePath =caracteristics.basePath;
      demandeA = DateTime.now();
      departA = null;
      arriveA = null;
    });
  }


}