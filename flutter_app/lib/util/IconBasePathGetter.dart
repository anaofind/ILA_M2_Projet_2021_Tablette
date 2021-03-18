class IconBasePathGetter{

  static getImageBasePath(String nomSymbolOrCodeMoyen){
    String basePath;
    switch(nomSymbolOrCodeMoyen) {

      case 'Chemin': {basePath =  'Icone_Png/Chemin/';}break;
      case 'Fleche': {basePath =  'Icone_Png/Chemin/';}break;
      case 'Action': {basePath =  'Icone_Png/Danger/';}break;
      case 'Danger': {basePath =  'Icone_Png/Danger/';}break;
      case 'PointSensible': {basePath =  'Icone_Png/Danger/';}break;
      case 'Defense': {basePath =  'Icone_Png/Defense/';}break;
      case 'Perimetrale': {basePath =  'Icone_Png/Defense/';}break;
      case 'Infrastructure': {basePath =  'Icone_Png/Infrastructure/';}break;
      case 'Aerien': {basePath =  'Icone_Png/Infrastructure/Aérien/';}break;
      case 'Colonne': {basePath =  'Icone_Png/Infrastructure/Vehicule/';}break;
      case 'Groupe': {basePath =  'Icone_Png/Infrastructure/Vehicule/';}break;
      case 'Autre': {basePath =  'Icone_Png/Infrastructure/Vehicule/Autre/';}break;
      case 'FPT': {basePath =  'Icone_Png/Infrastructure/Vehicule/FPT/';}break;
      case 'VLCG': {basePath =  'Icone_Png/Infrastructure/Vehicule/VLCG/';}break;
      case 'VSAV': {basePath =  'Icone_Png/Infrastructure/Vehicule/VSAV/';}break;
      case 'PointEau': {basePath =  'Icone_Png/';}break;
      case 'PosteCommandement': {basePath =  'Icone_Png/';}break;
      case 'NonPerienne': {basePath =  'Icone_Png/';}break;
      case 'Perienne': {basePath =  'Icone_Png/';}break;
      case 'Poste': {basePath =  'Icone_Png/';}break;
      case 'Ravitaillement': {basePath =  'Icone_Png/';}break;



    }
    return basePath;
  }
}