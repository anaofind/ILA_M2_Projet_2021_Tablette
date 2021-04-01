import 'package:flutter_app/models/Intervention.dart';
import 'package:flutter_app/models/InterestPoint.dart';
import 'package:flutter_app/models/Mission.dart';


class SelectorIntervention {
  static Function selectInterventionFunction;

  static Mission missionSelected;

  static selectIntervention(Intervention intervention) {
    missionSelected = null;
    selectInterventionFunction(intervention);
  }



}