import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/InterventionService.dart';


class MissionService {
  static final CollectionReference missions = FirebaseFirestore.instance.collection('missions');
  static final FirebaseStorage storage = FirebaseStorage.instance;

  static Future<bool> addMission(Intervention intervention) async{
    Mission mission = intervention.futureMission;
    List<QuerySnapshot> missionRunning = await getMissionsByState(intervention, StateMission.Running);
    int nbMissionRunning = missionRunning.length;
    if (await missionRunning.isEmpty) {
      mission.state = StateMission.Running;
    } else {
      mission.state = StateMission.Waiting;
    }
    mission.idIntervention = intervention.id;
    await missions.add(mission.toMap());
    intervention.missions.add(mission.id);
    intervention.futureMission = Mission(idIntervention: intervention.id);
    await InterventionService().updateIntervention(intervention);
    return true;
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
