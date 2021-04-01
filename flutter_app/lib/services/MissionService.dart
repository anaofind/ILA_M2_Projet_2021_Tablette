import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/InterventionService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MissionService {
  static final CollectionReference missions = FirebaseFirestore.instance.collection('missions');
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static final String urlServer = 'http://148.60.11.47:80/api/mission';

  static Future<bool> addMission(Intervention intervention) async{
    Mission mission = intervention.futureMission;
    mission.state = StateMission.Waiting;
    mission.idIntervention = intervention.id;

    http.Client client = http.Client();
    http.Response responsePost = await client.post(Uri.parse(urlServer),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json.encode(mission.toMap())
    );
    if (responsePost.statusCode == 200) {
      print (json.encode(mission.toMap()));
      await missions.add(mission.toMap());
      intervention.missions.add(mission.id);
      intervention.futureMission = Mission(idIntervention: intervention.id);
      await InterventionService().updateIntervention(intervention);
    }

    return responsePost.statusCode == 200;
  }

  static Future<bool> removeMission(Mission mission) async {
    DocumentSnapshot doc = await InterventionService().getInterventionById(mission.idIntervention).first;
    Intervention intervention = Intervention.fromSnapshot(doc);
    if (intervention != null) {
      intervention.missions.remove(mission.id);
      await InterventionService().updateIntervention(intervention);
      QuerySnapshot snapshot = await missions.where('id', isEqualTo: mission.id).limit(1).snapshots().first;
      missions.doc(snapshot.docs.first.id).delete();
      return true;
    }
    return false;
  }

  static Stream<QuerySnapshot> getMissionById(String id) {
    return missions.where('id' , isEqualTo: id).snapshots();
  }

  static Stream<DocumentSnapshot> getMission(String uid) {
    return missions.doc(uid).snapshots();
  }

  static Future<Reference> getPhotoByLink(String link) async{
    return await storage.refFromURL(link);
  }

  static Future<List<QuerySnapshot>> getMissionsByState(Intervention intervention, StateMission state) async {
    List<QuerySnapshot> snaphots = [];
    for (int i = 0; i<intervention.missions.length; i++) {
      String id = intervention.missions[i];
      QuerySnapshot snaphot =  await missions.where('id', isEqualTo: id).where('state', isEqualTo: state.toString()).snapshots().first;
      if (snaphot.docs.isNotEmpty) {
        snaphots.add(snaphot);
      }
    }

    return snaphots;
  }

}
