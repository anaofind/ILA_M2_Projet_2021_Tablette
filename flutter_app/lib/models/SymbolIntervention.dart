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

    //String icon = StringHelper.nomIconPngFromPath(PathIconPng);
    //SymbolCaracteristics caracteristics = StringHelper.caracteristicsFromString(icon);
    SymbolCaracteristics caracteristics = StringHelper.caracteristicsFromString(PathIconPng);
    if(caracteristics.typeSymbol=='M'){
      return MoyenIntervention.fromCaracteristicsAndPosition(caracteristics, position);}
    else{
      return SymbolIntervention.fromCaracteristicsAndPosition(caracteristics, position);
    }

  }
  static String createIconPathRelatedToObject(dynamic symbolOrMoyen){
    SymbolCaracteristics caracteristics = SymbolCaracteristics.fromSymbolOrMoyen(symbolOrMoyen);
    String pathIcon = StringHelper.fullPathIconfromCaracteristics(caracteristics);
    return pathIcon;
  }
}

class SymbolIntervention {
  String id;
  String nomSymbol;
  Color couleur;
  String etat;
  Position position;
  String basePath;

  SymbolIntervention(this.nomSymbol, this.position, this.couleur, this.etat, this.basePath):id = Uuid().v4();

  SymbolIntervention.fromCaracteristicsAndPosition(SymbolCaracteristics caracteristics, Position position){
    this.id = Uuid().v4();
    this.nomSymbol = caracteristics.nomSymbol;
    this.position =position;
    this.couleur =ColorConverter.colorFromString(caracteristics.couleur);
    this.etat = EtatFromCode(caracteristics.etat);
    this.basePath = caracteristics.basePath;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomSymbol': nomSymbol,
      'couleur': ColorConverter.stringFromColor(couleur),
      'etat': etat,
      'latitude': position!=null?position.latitude:null,
      'longitude': position!=null?position.longitude:null,
      'basePath': basePath,
    };
  }

  SymbolIntervention.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id'],
        nomSymbol = map['nomSymbol'],
        couleur = ColorConverter.colorFromString(map['couleur']),
        etat = map['etat'],
        position = Position( map['latitude'], map['longitude']),
        basePath = map['basePath'];

  static String EtatFromCode(String code){
    String ret;
    switch(code) {
      case '0': {ret =  Etat.prevu.toString();}break;
      case '1': {ret =  Etat.enCours.toString();}break;
    }
    return ret;
  }
  static String CodeFromEtat(String etat){
    String ret;
    switch(etat) {
      case 'Etat.prevu': {ret =  '0';}break;
      case 'Etat.enCours': {ret =  '1';}break;
    }
    return ret;
  }

}

class SymbolCaracteristics {
  String typeSymbol;
  String nomSymbol;
  String couleur;
  String etat;
  String basePath;
  SymbolCaracteristics(this.typeSymbol, this.nomSymbol, this.couleur, this.etat, this.basePath);

  SymbolCaracteristics.fromSymbolOrMoyen(dynamic symbolOrMoyen){
    if (symbolOrMoyen is MoyenIntervention){
      this.typeSymbol='M';
      this.nomSymbol = symbolOrMoyen.moyen.codeMoyen;
      this.couleur =ColorConverter.stringFromColorCaracteristics(symbolOrMoyen.couleur);
      this.etat=SymbolIntervention.CodeFromEtat(symbolOrMoyen.etat);
      this.basePath = symbolOrMoyen.basePath;
    };
    if (symbolOrMoyen is SymbolIntervention){
      this.typeSymbol='S';
      this.nomSymbol = symbolOrMoyen.nomSymbol;
      this.couleur =ColorConverter.stringFromColorCaracteristics(symbolOrMoyen.couleur);
      this.etat=SymbolIntervention.CodeFromEtat(symbolOrMoyen.etat);
      this.basePath = symbolOrMoyen.basePath;
    };
  }

}