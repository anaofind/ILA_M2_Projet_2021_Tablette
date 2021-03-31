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
  StateMission state = StateMission.Waiting;
  String idIntervention;


  Mission({this.idIntervention, this.name, this.interestPoints, this.segment, this.streamVideo}):id = Uuid().v4() {
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

  Mission duplicate() {
    Mission mission = Mission(
      idIntervention: this.idIntervention,
      name: this.name,
      segment: this.segment,
      streamVideo: this.streamVideo,
      interestPoints: this.interestPoints.toList(),
    );
    return mission;
  }

  static List<InterestPoint> convertInterestPointsToList(List<dynamic> listMap) {
    if (listMap == null) {
      return null;
    }
    List<InterestPoint> interestPoints = [];
    listMap.forEach((mapInterestPoint) {
      InterestPoint interestPoint = InterestPoint.fromMap(mapInterestPoint);
      interestPoints.add(interestPoint);
    });
    return interestPoints;
  }

  static List<String> convertPhotosToList(List<dynamic> listMap) {
    if (listMap == null) {
      return [];
    }
    List<String> photos = [];
    listMap.forEach((mapPhoto) {
      String urlPhoto = mapPhoto['url'];
      photos.add(urlPhoto);
    });
    return photos;
  }


  static List<Map<String, dynamic>> convertInterestPointsToMap(List<InterestPoint> list) {
    List<Map<String, dynamic>> listMap = [];
    list.forEach((element) {
      listMap.add(element.toMap());
    });
    return listMap;
  }

  static StateMission stateToString(String stateString) {
    switch(stateString) {
      case "StateMission.Waiting" :
        return StateMission.Waiting;
      case "StateMission.Running" :
        return StateMission.Running;
      case "StateMission.Ending" :
        return StateMission.Ending;
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : this.id,
      'name' : this.name,
      'interestPoints' : convertInterestPointsToMap(this.interestPoints),
      'photos' : this.photos,
      'segment': this.segment,
      'streamVideo': this.streamVideo,
      'state' : this.state.toString(),
      'video' : this.video,
      'idIntervention' : this.idIntervention
    };
  }

  Mission.fromMap(Map<String, dynamic> map) :
        assert(map != null),
        id = map['id'],
        name = map['name'],
        interestPoints = convertInterestPointsToList(map['interestPoints']),
        photos = convertPhotosToList(map['photos']),
        video = map['video'],
        segment = map['segment'],
        streamVideo = map['streamVideo'],
        state = stateToString(map['state']),
        idIntervention = map['idIntervention'];

  Mission.fromSnapshot(DocumentSnapshot snapshot) :
        assert(snapshot != null),
        id = snapshot.data()['id'],
        name = snapshot.data()['name'],
        interestPoints = convertInterestPointsToList(snapshot.data()['interestPoints']),
        photos = convertPhotosToList(snapshot.data()['photos']),
        video = snapshot.data()['video'],
        segment = snapshot.data()['segment'],
        streamVideo = snapshot.data()['streamVideo'],
        state = (snapshot.data()['state'] != null)? stateToString(snapshot.data()['state']): StateMission.Waiting,
        idIntervention = (snapshot.data()['idIntervention'] != null)? snapshot.data()['idIntervention']: '';
}


enum StateMission {
  Waiting,
  Running,
  Ending
}