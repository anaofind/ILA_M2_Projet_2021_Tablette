

class Feature {
  Feature({
    this.type,
    this.geometry,
    this.properties,
  });

  String type;
  Geometry geometry;
  Properties properties;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
    type: json["type"],
    geometry: Geometry.fromJson(json["geometry"]),
    properties: Properties.fromJson(json["properties"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "geometry": geometry.toJson(),
    "properties": properties.toJson(),
  };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    type: json["type"],
    coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
  };
}

class Properties {
  Properties({
    this.label,
    this.score,
    this.housenumber,
    this.id,
    this.name,
    this.postcode,
    this.citycode,
    this.x,
    this.y,
    this.city,
    this.district,
    this.context,
    this.type,
    this.importance,
    this.street,
  });

  String label;
  double score;
  String housenumber;
  String id;
  String name;
  String postcode;
  String citycode;
  double x;
  double y;
  String city;
  String district;
  String context;
  String type;
  double importance;
  String street;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
    label: json["label"],
    score: json["score"].toDouble(),
    housenumber: json["housenumber"] == null ? null : json["housenumber"],
    id: json["id"],
    name: json["name"],
    postcode: json["postcode"],
    citycode: json["citycode"],
    x: json["x"].toDouble(),
    y: json["y"].toDouble(),
    city: json["city"],
    district: json["district"],
    context: json["context"],
    type: json["type"],
    importance: json["importance"].toDouble(),
    street: json["street"] == null ? null : json["street"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "score": score,
    "housenumber": housenumber == null ? null : housenumber,
    "id": id,
    "name": name,
    "postcode": postcode,
    "citycode": citycode,
    "x": x,
    "y": y,
    "city": city,
    "district": district,
    "context": context,
    "type": type,
    "importance": importance,
    "street": street == null ? null : street,
  };
}