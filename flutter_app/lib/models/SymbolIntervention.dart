import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:flutter_app/util/ColorConverter.dart';
import 'package:flutter_app/util/StringHelper.dart';

import 'Moyen.dart';
import 'MoyenIntervention.dart';
import 'Position.dart';
import 'package:uuid/uuid.dart';

class SymbolDecider {
  static dynamic createObjectRelatedToSymbol(String PathIconPng, Position position){

    String icon = StringHelper.nomIconPngFromPath(PathIconPng);
    SymbolCaracteristics caracteristics = StringHelper.caracteristicsFromString(icon);
    if(caracteristics.typeSymbol=='M'){
      return MoyenIntervention.fromCaracteristicsAndPosition(caracteristics, position);}
      else{
      return SymbolIntervention.fromCaracteristicsAndPosition(caracteristics, position);
    }

  }
}

class SymbolIntervention {
  String id;
  String nomSymbol;
  Color couleur;
  String etat;
  Position position;

  SymbolIntervention(this.nomSymbol, this.position, this.couleur, this.etat):id = Uuid().v4();

  SymbolIntervention.fromCaracteristicsAndPosition(SymbolCaracteristics caracteristics, Position position){
    this.id = Uuid().v4();
    this.nomSymbol = caracteristics.nomSymbol;
    this.position =position;
    this.couleur =ColorConverter.colorFromString(caracteristics.couleur);
    this.etat = EtatFromCode(caracteristics.etat);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomSymbol': nomSymbol,
      'couleur': ColorConverter.stringFromColor(couleur),
      'etat': etat,
      'latitude': position!=null?position.latitude:null,
      'longitude': position!=null?position.longitude:null,
    };
  }

  SymbolIntervention.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id'],
        nomSymbol = map['nomSymbol'],
        couleur = ColorConverter.colorFromString(map['couleur']),
        etat = map['etat'],
        position = Position( map['latitude'], map['longitude']);

  static String EtatFromCode(String code){
    String ret;
    switch(code) {
      case '0': {ret =  Etat.prevu.toString();}break;
      case '1': {ret =  Etat.enCours.toString();}break;
    }
    return ret;
  }

}

class SymbolCaracteristics {
  String typeSymbol;
  String nomSymbol;
  String couleur;
  String etat;
  SymbolCaracteristics(this.typeSymbol, this.nomSymbol, this.couleur, this.etat);

}