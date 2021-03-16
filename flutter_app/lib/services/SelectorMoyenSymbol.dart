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
      case 'M_FPT_Rouge_1' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_1.png';
        break;
      case 'M_FPT_Rouge_0' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/FPT/M_FPT_Rouge_0.png';
        break;
      case 'M_VLCG_Rouge_1' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_1.png';
        break;
      case 'M_VLCG_Rouge_0' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Rouge_0.png';
        break;
      case 'M_VLCG_Vert_1' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_1.png';
        break;
      case 'M_VLCG_Vert_0' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VLCG/M_VLCG_Vert_0.png';
        break;
      case 'M_VSAV_Vert_1' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_1.png';
        break;
      case 'M_VSAV_Vert_0' :
        pathImage = 'Icone_Png/Infrastructure/Vehicule/VSAV/M_VSAV_Vert_0.png';
        break;
      case 'S_Poste_Violet_1' :
        pathImage = 'Icone_Png/S_Poste_Violet_1.png';
        break;
      case 'S_Poste_Violet_0' :
        pathImage = 'Icone_Png/S_Poste_Violet_0.png';
        break;
      case 'S_Action_Rouge_1' :
        pathImage = 'Icone_Png/Danger/S_Action_Rouge_1.png';
        break;
      case 'S_Action_Vert_1' :
        pathImage = 'Icone_Png/Danger/S_Action_Vert_1.png';
        break;
      case 'S_Action_Bleu_1' :
        pathImage = 'Icone_Png/Danger/S_Action_Bleu_1.png';
        break;
      case 'S_Action_Orange_1' :
        pathImage = 'Icone_Png/Danger/S_Action_Orange_1.png';
        break;
      case 'S_Danger_Rouge_1' :
        pathImage = 'Icone_Png/Danger/S_Danger_Rouge_1.png';
        break;
      case 'S_PointSensible_Rouge_1' :
        pathImage = 'Icone_Png/Danger/S_PointSensible_Rouge_1.png';
        break;
      case 'S_Danger_Vert_1' :
        pathImage = 'Icone_Png/Danger/S_Danger_Vert_1.png';
        break;
      case 'S_PointSensible_Vert_1' :
        pathImage = 'Icone_Png/Danger/S_PointSensible_Vert_1.png';
        break;
      case 'S_Danger_Bleu_1' :
        pathImage = 'Icone_Png/Danger/S_Danger_Bleu_1.png';
        break;
      case 'S_PointSensible_Bleu_1' :
        pathImage = 'Icone_Png/Danger/S_PointSensible_Bleu_1.png';
        break;
      case 'S_Danger_Orange_1' :
        pathImage = 'Icone_Png/Danger/S_Danger_Orange_1.png';
        break;
      case 'S_PointSensible_Orange_1' :
        pathImage = 'Icone_Png/Danger/S_PointSensible_Orange_1.png';
        break;
      case 'S_Perienne_Bleu_1' :
        pathImage = 'Icone_Png/S_Perienne_Bleu_1.png';
        break;
      case 'S_NonPerienne_Bleu_1' :
        pathImage = 'Icone_Png/S_NonPerienne_Bleu_1.png';
        break;
      case 'S_Ravitaillement_Bleu_1' :
        pathImage = 'Icone_Png/S_Ravitaillement_Bleu_1.png';
        break;
      case 'S_Defense_Rouge_1' :
        pathImage = 'Icone_Png/Defense/S_Defense_Rouge_1.png';
        break;
      case 'S_Defense_Rouge_0' :
        pathImage = 'Icone_Png/Defense/S_Defense_Rouge_0.png';
        break;
      case 'S_Defense_Vert_1' :
        pathImage = 'Icone_Png/Defense/S_Defense_Vert_1.png';
        break;
      case 'S_Defense_Vert_0' :
        pathImage = 'Icone_Png/Defense/S_Defense_Vert_0.png';
        break;
      case 'S_Defense_Bleu_1' :
        pathImage = 'Icone_Png/Defense/S_Defense_Bleu_1.png';
        break;
      case 'S_Defense_Bleu_0' :
        pathImage = 'Icone_Png/Defense/S_Defense_Bleu_0.png';
        break;
      case 'S_Defense_Orange_1' :
        pathImage = 'Icone_Png/Defense/S_Defense_Orange_1.png';
        break;
      case 'S_Defense_Orange_0' :
        pathImage = 'Icone_Png/Defense/S_Defense_Orange_0.png';
        break;
      case 'S_Perimetrale_Rouge_1' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Rouge_1.png';
        break;
      case 'S_Perimetrale_Rouge_0' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Rouge_0.png';
        break;
      case 'S_Perimetrale_Vert_1' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Vert_1.png';
        break;
      case 'S_Perimetrale_Vert_0' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Vert_0.png';
        break;
      case 'S_Perimetrale_Bleu_1' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Bleu_1.png';
        break;
      case 'S_Perimetrale_Bleu_0' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Bleu_0.png';
        break;
      case 'S_Perimetrale_Orange_1' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Orange_1.png';
        break;
      case 'S_Perimetrale_Orange_0' :
        pathImage = 'Icone_Png/Defense/S_Perimetrale_Orange_0.png';
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
    }
    return pathImage;
  }
}