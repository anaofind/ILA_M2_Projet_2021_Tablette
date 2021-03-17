import 'package:flutter_app/models/SymbolIntervention.dart';

class StringHelper {
  static String nomIconPngFromPath(String path) {
    var deb = path.lastIndexOf('/');
    String withoutBase = (deb != -1)? path.substring(deb+1): path;
    var fin = withoutBase.lastIndexOf('.');
    String withoutExtention = (fin != -1)? withoutBase.substring(0, fin): withoutBase;
    return withoutExtention;
  }

  static SymbolCaracteristics caracteristicsFromString(String iconPngName) {
    List<String> parts = iconPngName.split("_");
    SymbolCaracteristics caracteristics = SymbolCaracteristics(parts[0], parts[1], parts[2], parts[3]);
    return caracteristics;
  }
}