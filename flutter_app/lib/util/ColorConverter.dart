import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConverter{
  static Color colorFromString(String color){
    Color ret;
    switch(color) {
      case 'Colors.black': {ret =  Colors.black;}break;
      case 'Colors.green': {ret =  Colors.green;}break;
      case 'Colors.red': {ret =  Colors.red;}break;
      case 'Colors.blue': {ret =  Colors.blue;}break;
      case 'Colors.orange': {ret =  Colors.orange;}break;
      case 'Colors.purple': {ret =  Colors.purple;}break;
    }
    return ret;
  }
  static String stringFromColor(Color color){
    String ret;
    if(color == Colors.black){ret =  'Colors.black';}
    if(color == Colors.green){ret =  'Colors.green';}
    if(color == Colors.red){ret =  'Colors.red';}
    if(color == Colors.blue){ret =  'Colors.blue';}
    if(color == Colors.orange){ret =  'Colors.orange';}
    if(color == Colors.purple){ret =  'Colors.purple';}
    return ret;
  }
}