class Intervention {
  String nom;
  String codeSinistre;
  String adresse;
  DateTime dateEvent;

  Intervention(String nom, String code, String adresse, DateTime laDate) {
    this.nom = nom;
    this.codeSinistre = code;
    this.adresse = adresse;
    this.dateEvent = laDate;
  }

  String get getNom {
    return this.nom;
  }

  void set setNom(String name) {
    this.nom = name;
  }

  String get getCode {
    return this.codeSinistre;
  }

  void set setCode(String code) {
    this.codeSinistre = code;
  }

  String get getAdresse {
    return this.adresse;
  }

  void set setAdresse(String add) {
    this.adresse = add;
  }
  DateTime get getDate {
    return this.dateEvent;
  }

  void set setDate(DateTime dt) {
    this.dateEvent = dt;
  }
}