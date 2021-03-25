import 'package:flutter_app/models/Intervention.dart';

class SelectorIntervention {
  static Function selectInterventionFunction;

  static int idMissionSelected = 0;

  static selectIntervention(Intervention intervention) {
    selectInterventionFunction(intervention);
  }



}