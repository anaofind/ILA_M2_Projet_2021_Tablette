enum Etat {
  enCours,
  prevu
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
}