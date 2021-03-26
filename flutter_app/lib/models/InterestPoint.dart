import 'package:flutter_app/models/Position.dart';

class InterestPoint {
  Position position;
  bool photo;

  Map<String, dynamic> toMap() {
    return {
      'latitude' : position.latitude,
      'longitude' : position.longitude,
      'photo' : photo
    };
  }

  InterestPoint.fromMap(Map<String, dynamic> map) :
      assert(map != null),
      position = Position( map['latitude'], map['longitude']);

}