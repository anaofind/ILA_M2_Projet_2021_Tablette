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
}