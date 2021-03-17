import 'package:flutter_app/models/SymbolIntervention.dart';

class StringHelper {
  static String nomIconPngFromPath(String path) {
    var deb = path.lastIndexOf('/');
    String withoutBase = (deb != -1)? path.substring(deb+1): path;
    var fin = withoutBase.lastIndexOf('.');
    String withoutExtention = (fin != -1)? withoutBase.substring(0, fin): withoutBase;
    return withoutExtention;
  }
  static String basePathIcon(String path) {
    var index = path.lastIndexOf('/');
    String base = (index != -1)? path.substring(0, index+1): path;
    return base;
  }

  static SymbolCaracteristics caracteristicsFromString(String iconPngPathName) {
    String nomIcon = nomIconPngFromPath(iconPngPathName);
    String base = basePathIcon(iconPngPathName);
    List<String> parts = nomIcon.split("_");
    SymbolCaracteristics caracteristics = SymbolCaracteristics(parts[0], parts[1], parts[2], parts[3], base);
    return caracteristics;
  }

  static String fullPathIconfromCaracteristics(SymbolCaracteristics caracteristics) {
    String path=caracteristics.basePath+caracteristics.typeSymbol+'_'+caracteristics.nomSymbol+'_'+caracteristics.couleur+'_'+caracteristics.etat+'.png';
    return path;
  }
}