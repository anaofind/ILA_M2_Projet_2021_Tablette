import 'package:flutter_app/models/Position.dart';

class Mission {

  final String id;
  List<Position> positions;
  List<String> photos;
  String video;

  Mission({this.id, this.video}): this.positions = [],  this.photos = [];


  static List<Position> convertPositionsToList(List<Map<String, dynamic>> listMap) {
    List<Position> positions = [];
    listMap.forEach((mapPosition) {
      Position position = Position( mapPosition['latitude'], mapPosition['longitude']);
      positions.add(position);
    });
    return positions;
  }

  static List<String> convertPhotosToList(List<Map<String, dynamic>> listMap) {
    List<String> photos = [];
    listMap.forEach((mapPhoto) {
      String urlPhoto = mapPhoto['url'];
      photos.add(urlPhoto);
    });
    return photos;
  }


  Map<String, dynamic> toMap() {
    return {
      'id' : this.id
    };
  }

  Mission.fromMapId(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id']
  ;

  Mission.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id'],
        positions = convertPositionsToList(map['positions']),
        photos = convertPhotosToList(map['photos']),
        video = map['video']
  ;

}