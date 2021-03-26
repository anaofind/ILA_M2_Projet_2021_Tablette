import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/InterestPoint.dart';
import 'package:flutter_app/models/Position.dart';

class Mission {

  final String id;
  List<InterestPoint> interestPoints = [];
  List<String> photos = [];
  String video;
  bool segment = false;
  bool streamVideo = false;


  Mission({this.id, this.video, this.photos, this.interestPoints, this.segment, this.streamVideo});


  static List<InterestPoint> convertInterestPointsToList(List<Map<String, dynamic>> listMap) {
    List<InterestPoint> interestPoints = [];
    listMap.forEach((mapInterestPoint) {
      InterestPoint interestPoint = InterestPoint.fromMap(mapInterestPoint);
      interestPoints.add(interestPoint);
    });
    return interestPoints;
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
      'id' : this.id,
      'interestPoints' : this.interestPoints,
      'photos' : this.photos,
      'segment': this.segment,
      'streamVideo': this.streamVideo
    };
  }

  Mission.fromMap(Map<String, dynamic> map)
      : assert(map != null),
        id = map['id'],
        interestPoints = convertInterestPointsToList(map['interestPoints']),
        photos = convertPhotosToList(map['photos']),
        video = map['video'],
        segment = map['segment'],
        streamVideo = map['streamVideo']
  ;

  Mission.fromSnapshot(DocumentSnapshot snapshot) :
        assert(snapshot != null),
        id = snapshot.data()['id'],
        interestPoints = convertInterestPointsToList(snapshot.data()['interestPoints']),
        photos = convertPhotosToList(snapshot.data()['photos']),
        video = snapshot.data()['video'],
        segment = snapshot.data()['segment'],
        streamVideo = snapshot.data()['streamVideo'];


}