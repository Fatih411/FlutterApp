import 'package:flutter/material.dart';

class ConstanstStyle {
  static TextStyle appbarText() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: _fontsize(22));
  }

  static double _fontsize(double size) {
    return size;
  }

  static TextStyle dateTimeStlye() {
    return TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontSize: _fontsize(15));
  }

  static TextStyle textFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: _fontsize(16));
  }
}
