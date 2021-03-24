import 'package:flutter/material.dart';
import 'package:flutter_app/models/Position.dart';
import 'package:flutter_app/models/SymbolIntervention.dart';


class HydrantData {
  static final String basePath = 'Icone_Png/';

  final Position position;
  final String type;
  final String note;

  HydrantData({@required this.position, @required this.type, @required this.note});

  factory HydrantData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('geo_point_2d') && json.containsKey('fire_hydrant_type')) {
      double lat = json['geo_point_2d'][0];
      double lng = json['geo_point_2d'][1];
      Position position = Position(lat, lng);
      String type = json['fire_hydrant_type'];
      String note = (json.containsKey('note'))? json['note']: 'Aucune description';
      return HydrantData(
          position: position,
          type: type,
          note: note
      );
    }
    print('BAD HYDRANT');

  }


  SymbolIntervention getSymbol() {
    switch (type) {
      case 'pillar' :
        return createSymbolNonPerienne();
      case 'underground' :
        return createSymbolPerienne();
      case 'pond' :
        return createSymbolPerienne();
      case 'wall' :
        return createSymbolNonPerienne();
      case 'pipe' :
        return createSymbolNonPerienne();
      case 'column' :

      case 'suction_point' :

      case 'colonne' :

      case 'dry_hydrant' :

      case 'no' :

      case 'borne incendie' :

      case 'cc' :

      case 'unknown' :

      case 'bollar' :

      case 'pilar' :

      case 'pilkar' :

      case 'poteau' :

      case 'standpipe' :

      case '12' :

      case '93' :

      case 'C' :

      case 'PI' :

      case 'bassin' :

      case 'bollard' :

      case 'colon' :

      case 'extinguisher' :

      case 'pi100' :

      case 'pil' :

      case 'piljar' :

      case 'stand_pipe' :

      case 'underground;pillar' :

      case 'yes' :

    }
  }

  SymbolIntervention createSymbolPerienne() {
    return SymbolIntervention('Perienne', this.position, Colors.blue, 'Etat.enCours', basePath);
  }

  SymbolIntervention createSymbolNonPerienne() {
    return SymbolIntervention('NonPerienne', this.position, Colors.blue, 'Etat.enCours', basePath);
  }

  SymbolIntervention createSymbolRavitaillement() {
    return SymbolIntervention('Ravitaillement', this.position, Colors.blue, 'Etat.enCours', basePath);
  }
}