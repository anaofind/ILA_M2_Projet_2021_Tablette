import 'Moyen.dart';

class MoyenInterventionDocument {
    List<MoyenIntervention> moyensIntervention;
}

class MoyenIntervention {
  final Moyen moyen;
  final String etat;
  final DateTime demandeA;
  final DateTime departA;
  final DateTime arriveA;

  MoyenIntervention(this.moyen, this.etat, this.demandeA, this.departA, this.arriveA);


  Map<String, dynamic> toMap() {
    return {
      'codeMoyen': moyen.codeMoyen,
      'description': moyen.description,
      'couleurDefaut': moyen.couleurDefaut,
      'etat': etat,
      'demandeA': demandeA,
      'departA': departA,
      'arriveA': arriveA
    };
  }
  MoyenIntervention.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        moyen = Moyen(null, map['codeMoyen'], map['description'], map['couleurDefaut']),
        etat = map['etat'],
        demandeA = map['demandeA'].toDate(),
        departA = map['departA']!=null?map['departA'].toDate():null,
        arriveA = map['arriveA']!=null?map['arriveA'].toDate():null;


}
