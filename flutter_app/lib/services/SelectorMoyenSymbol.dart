class SelectorMoyenSymbol {

  static String pathImage;

  static bool isSelected() {
    return (pathImage != null);
  }

  static void deselect() {
    pathImage = null;
  }

}