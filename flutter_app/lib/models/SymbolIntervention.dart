import 'package:cloud_firestore/cloud_firestore.dart';

import 'Position.dart';
import 'package:uuid/uuid.dart';

class SymbolIntervention {
  final String id;
  final String nomSymbol;
  Position position;

  SymbolIntervention(this.nomSymbol, this.position):id = Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomSymbol': nomSymbol,
      'latitude': position!=null?position.latitude:null,
      'longitude': position!=null?position.longitude:null,
    };
  }

  SymbolIntervention.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id'],
        nomSymbol = map['nomSymbol'],
        position = Position( map['latitude'], map['longitude']);

}