import 'package:flutter/material.dart';

class NavigatorPage {

  static Function refreshFunction;
  static int indexSelectedPage = 0;

  static navigateTo(int indexPage) {
    indexSelectedPage = indexPage;
    refreshFunction();
  }

}