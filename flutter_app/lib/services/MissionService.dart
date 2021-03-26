import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/InterventionService.dart';

class MissionService {

  static CollectionReference missions = FirebaseFirestore.instance.collection('missions');

  static Future<void> addMission(Intervention intervention) async{
    missions.add(intervention.futureMission.toMap()).then((m) {
      intervention.missions.add(intervention.futureMission.id);
      intervention.futureMission = Mission();
      InterventionService().updateIntervention(intervention);
    });
  }

  static Stream<QuerySnapshot> getMissionById(String id) {
    return missions.where('id' , isEqualTo: id).snapshots();
  }

  static Stream<DocumentSnapshot> getMission(String uid) {
    return missions.doc(uid).snapshots();
  }

}
