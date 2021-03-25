import 'package:cloud_firestore/cloud_firestore.dart';

enum Etat {
  enCours,
  prevu,
  enAttente,
  retourne
}
class Moyen {
  final String id;
  final String codeMoyen;
  final String description;
  final String couleurDefaut;

  Moyen(this.id, this.codeMoyen, this.description, this.couleurDefaut);

  Map<String, dynamic> toMap() {
    return {
      'codeMoyen': codeMoyen,
      'description': description,
      'couleurDefaut': couleurDefaut
    };
  }
  Moyen.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        codeMoyen = snapshot.data()['codeMoyen'],
        description = snapshot.data()['description'],
        couleurDefaut = snapshot.data()['couleurDefaut'];


}