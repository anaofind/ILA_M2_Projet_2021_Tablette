import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/Mission.dart';
import 'package:flutter_app/services/InterventionService.dart';

class MissionService {

  static CollectionReference missions = FirebaseFirestore.instance.collection('missions');

  static Future<void> addMission(Intervention intervention) {
    missions.add({
      'positions': [],
      'photos': [],
      'video': []
    }).then((m) {
      Mission mission = Mission(id: m.id);
      intervention.missions.add(mission);
      InterventionService().updateIntervention(intervention);
    });
  }

}