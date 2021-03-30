import 'package:flutter_app/models/Intervention.dart';

class SelectorIntervention {
  static Function selectInterventionFunction;

  static String idMissionSelected;

  static selectIntervention(Intervention intervention) {
    idMissionSelected = null;
    selectInterventionFunction(intervention);
  }



}