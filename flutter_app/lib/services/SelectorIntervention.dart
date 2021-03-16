import 'package:flutter_app/models/Intervention.dart';

class SelectorIntervention {
  static Function selectInterventionFunction;

  static selectIntervention(Intervention intervention) {
    selectInterventionFunction(intervention);
  }

}