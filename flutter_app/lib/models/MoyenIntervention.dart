import 'dart:ui';
import 'package:uuid/uuid.dart';
import 'package:flutter_app/util/ColorConverter.dart';

import 'Moyen.dart';

class MoyenInterventionDocument {
    List<MoyenIntervention> moyensIntervention;
}

class MoyenIntervention {
  final Moyen moyen;
  final String id;
  String etat;
  DateTime demandeA;
  DateTime departA;
  DateTime arriveA;
  final Color couleur;

  MoyenIntervention(this.moyen, this.etat, this.demandeA, this.departA, this.arriveA, this.couleur):id = Uuid().v4();


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
      'couleur': ColorConverter.stringFromColor(couleur)
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
        couleur = ColorConverter.colorFromString(map['couleur']);

}
