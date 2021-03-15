import 'package:cloud_firestore/cloud_firestore.dart';

class Sinistre {
  final String id;
  final String codeSinistre;
  final String description;

  Sinistre(this.id, this.codeSinistre, this.description);


  Map<String, dynamic> toMap() {
    return {
      'codeSinistre': codeSinistre,
      'description': description,
    };
  }

  Sinistre.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        codeSinistre = snapshot.data()['codeSinistre'],
        description = snapshot.data()['description'];
}