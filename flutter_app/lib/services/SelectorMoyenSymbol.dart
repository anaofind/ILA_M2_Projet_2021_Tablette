class SelectorMoyenSymbol {

  static String name;
  static String type;

  static bool isSelected() {
    return (name != null && type != null);
  }

  static String getPathImage() {
    return getPathImageByName(name);
  }

  static String getPathImageByName(String name) {
    String pathImage;
    switch (name) {
      case 'Cible_Action_Incendie' :
        pathImage = 'Icone_Png/Danger/CibleAction_Incendie.png';
        break;
      case 'Cible_Action_Civil' :
        pathImage = 'Icone_Png/Danger/CibleAction_Civil.png';
        break;
      case 'Cible_Action_Eau' :
        pathImage = 'Icone_Png/Danger/CibleAction_Eau.png';
        break;
      case 'Cible_Action_Particulier' :
        pathImage = 'Icone_Png/Danger/CibleAction_Particulier.png';
        break;
      case 'Danger_Incendie' :
        pathImage = 'Icone_Png/Danger/Danger_Incendie.png';
        break;
      case 'PointSensible_Incendie' :
        pathImage = 'Icone_Png/Danger/PointSensible_Incendie.png';
        break;
      case 'Danger_Civil' :
        pathImage = 'Icone_Png/Danger/Danger_Civil.png';
        break;
      case 'PointSensible_Civil' :
        pathImage = 'Icone_Png/Danger/PointSensible_Civil.png';
        break;
      case 'Danger_Eau' :
        pathImage = 'Icone_Png/Danger/Danger_Eau.png';
        break;
      case 'PointSensible_Eau' :
        pathImage = 'Icone_Png/Danger/PointSensible_Eau.png';
        break;
      case 'Danger_Particulier' :
        pathImage = 'Icone_Png/Danger/Danger_Particulier.png';
        break;
      case 'PointSensible_Particulier' :
        pathImage = 'Icone_Png/Danger/PointSensible_Particulier.png';
        break;
      case 'PointEau_Perienne' :
        pathImage = 'Icone_Png/PointEau_Perienne.png';
        break;
      case 'PointEau_NonPerienne' :
        pathImage = 'Icone_Png/PointEau_NonPerienne.png';
        break;
      case 'PointEau_Ravitaillement' :
        pathImage = 'Icone_Png/PointEau_Ravitaillement.png';
        break;
      case 'Defense_Incendie_Encours' :
        pathImage = 'Icone_Png/Defense/Defense_Incendie_Encours.png';
        break;
      case 'Defense_Incendie_Prevue' :
        pathImage = 'Icone_Png/Defense/Defense_Incendie_Prevue.png';
        break;
      case 'Defense_Civil_Encours' :
        pathImage = 'Icone_Png/Defense/Defense_Civil_Encours.png';
        break;
      case 'Defense_Civil_Prevue' :
        pathImage = 'Icone_Png/Defense/Defense_Civil_Prevue.png';
        break;
      case 'Defense_Eau_Encours' :
        pathImage = 'Icone_Png/Defense/Defense_Eau_Encours.png';
        break;
      case 'Defense_Eau_Prevue' :
        pathImage = 'Icone_Png/Defense/Defense_Eau_Prevue.png';
        break;
      case 'Defense_Particulier_Encours' :
        pathImage = 'Icone_Png/Defense/Defense_Particulier_Encours.png';
        break;
      case 'Defense_Particulier_Prevue' :
        pathImage = 'Icone_Png/Defense/Defense_Particulier_Prevue.png';
        break;
      case 'Perimetrale_Incendie_Encours' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Incendie_Encours.png';
        break;
      case 'Perimetrale_Incendie_Prevue' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Incendie_Prevue.png';
        break;
      case 'Perimetrale_Civil_Encours' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Civil_Encours.png';
        break;
      case 'Perimetrale_Civil_Prevue' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Civil_Prevue.png';
        break;
      case 'Perimetrale_Eau_Encours' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Eau_Encours.png';
        break;
      case 'Perimetrale_Eau_Prevue' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Eau_Prevue.png';
        break;
      case 'Perimetrale_Particulier_Encours' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Particulier_Encours.png';
        break;
      case 'Perimetrale_Particulier_Prevue' :
        pathImage = 'Icone_Png/Defense/Perimetrale_Particulier_Prevue.png';
        break;
      case 'Chemin_Encours' :
        pathImage = 'Icone_Png/Chemin/Chemin_Encours.png';
        break;
      case 'Chemin_Prevue' :
        pathImage = 'Icone_Png/Chemin/Chemin_Prevue.png';
        break;
      case 'Infrastructure_Civil_EnCours' :
        pathImage = 'Icone_Png/Infrastructure_Civil_EnCours.png';
        break;
      case 'Infrastructure_Civil_EnCours' :
        pathImage = 'Icone_Png/Infrastructure_Civil_EnCours.png';
        break;
      case 'Infrastructure_Civil_EnCours' :
        pathImage = 'Icone_Png/Infrastructure_Civil_EnCours.png';
        break;
      case 'FPT_Unique_Encours' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Encours.png';
        break;
      case 'FPT_Unique_Prevue' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/FPT_Unique_Prevue.png';
        break;
      case 'VLGC_Unique_Rouge_Encours' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Encours.png';
        break;
      case 'VLGC_Unique_Rouge_Prevue' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Rouge_Prevue.png';
        break;
      case 'VLGC_Unique_Vert_Encours' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Encours.png';
        break;
      case 'VLGC_Unique_Vert_Prevue' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/VLGC_Unique_Vert_Prevue.png';
        break;
      case 'VSAV_Unique_Encours' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Encours.png';
        break;
      case 'VSAV_Unique_Prevue' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/VSAV_Unique_Prevue.png';
        break;
      case 'PosteCommandement_Seul_Encours' :
        pathImage = 'Icone_Png/PosteCommandement_Seul_Encours.png';
        break;
      case 'PosteCommandement_Seul_Prevue' :
        pathImage = 'Icone_Png/PosteCommandement_Seul_Prevue.png';
        break;
    }
    return pathImage;
  }
}