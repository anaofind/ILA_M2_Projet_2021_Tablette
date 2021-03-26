import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/InterestPoint.dart';
import 'package:uuid/uuid.dart';

class Mission {

  String id;
  String name;
  List<InterestPoint> interestPoints = [];
  List<String> photos = [];
  String video;
  bool segment = true;
  bool streamVideo = false;


  Mission({this.name, this.interestPoints, this.segment, this.streamVideo}):id = Uuid().v4() {
    if (this.name == null) {
      this.name = this.id;
    }
    if (this.interestPoints == null) {
      this.interestPoints = [];
    }
    if (this.segment == null) {
      this.segment = false;
    }
    if (this.streamVideo == null) {
      this.streamVideo = false;
    }
  }


  static List<InterestPoint> convertInterestPointsToList(List<dynamic> listMap) {
    List<InterestPoint> interestPoints = [];
    listMap.forEach((mapInterestPoint) {
      InterestPoint interestPoint = InterestPoint.fromMap(mapInterestPoint);
      interestPoints.add(interestPoint);
    });
    return interestPoints;
  }

  static List<String> convertPhotosToList(List<dynamic> listMap) {
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
      'name' : this.name,
      'interestPoints' : this.interestPoints,
      'photos' : this.photos,
      'segment': this.segment,
      'streamVideo': this.streamVideo
    };
  }

  Mission.fromSnapshot(DocumentSnapshot snapshot) :
        assert(snapshot != null),
        id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        interestPoints = convertInterestPointsToList(snapshot.data()['interestPoints']),
        photos = convertPhotosToList(snapshot.data()['photos']),
        video = snapshot.data()['video'],
        segment = snapshot.data()['segment'],
        streamVideo = snapshot.data()['streamVideo'];


}