import 'dart:collection';
import 'dart:core';

import 'package:flutter_app/models/Position.dart';
import 'package:uuid/uuid.dart';

class MissionDrone {

  String id_intervention = "";
  String id_mission = "";
  String nom_de_la_mission = "";
  // True => Zone ; False => SEGMENTS
  bool type_de_la_mission = false;
  bool streamVideo = false;
  HashMap<Position,bool> positions_mission = new HashMap<Position,bool>();
  List<List<Position>> zone_exclusion = new List<List<Position>>();

  MissionDrone(this.id_intervention):id_mission = Uuid().v4();
}