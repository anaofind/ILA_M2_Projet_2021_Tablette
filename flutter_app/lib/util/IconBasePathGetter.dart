class IconBasePathGetter{

  static getImageBasePath(String nomSymbolOrCodeMoyen){
    String basePath;
    switch(nomSymbolOrCodeMoyen) {

      case 'Chemin': {basePath =  'Icone_png/Chemin/';}break;
      case 'Fleche': {basePath =  'Icone_png/Chemin/';}break;
      case 'Action': {basePath =  'Icone_png/Danger/';}break;
      case 'Danger': {basePath =  'Icone_png/Danger/';}break;
      case 'PointSensible': {basePath =  'Icone_png/Danger/';}break;
      case 'Defense': {basePath =  'Icone_png/Defense/';}break;
      case 'Perimetrale': {basePath =  'Icone_png/Defense/';}break;
      case 'Infrastructure': {basePath =  'Icone_png/Infrastructure/';}break;
      case 'Aerien': {basePath =  'Icone_png/Infrastructure/Aérien/';}break;
      case 'Colonne': {basePath =  'Icone_png/Infrastructure/Vehicule/';}break;
      case 'Groupe': {basePath =  'Icone_png/Infrastructure/Vehicule/';}break;
      case 'Autre': {basePath =  'Icone_png/Infrastructure/Vehicule/Autre/';}break;
      case 'FPT': {basePath =  'Icone_png/Infrastructure/Vehicule/FPT/';}break;
      case 'VLCG': {basePath =  'Icone_png/Infrastructure/Vehicule/VLCG/';}break;
      case 'VSAV': {basePath =  'Icone_png/Infrastructure/Vehicule/VSAV/';}break;
      case 'PointEau': {basePath =  'Icone_png/';}break;
      case 'PosteCommandement': {basePath =  'Icone_png/';}break;
      case 'NonPerienne': {basePath =  'Icone_png/';}break;
      case 'Perienne': {basePath =  'Icone_png/';}break;
      case 'Poste': {basePath =  'Icone_png/';}break;
      case 'Ravitaillement': {basePath =  'Icone_png/';}break;



    }
    return basePath;
  }
}