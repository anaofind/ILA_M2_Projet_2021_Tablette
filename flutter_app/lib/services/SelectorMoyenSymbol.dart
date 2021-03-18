import 'package:flutter_app/models/MoyenIntervention.dart';

class SelectorMoyenSymbol {

  static String pathImage;
  static int moyenId;

  static bool isSelected() {
    return (pathImage != null);
  }

  static void deselect() {
    pathImage = null;
    moyenId = -1;
  }

}