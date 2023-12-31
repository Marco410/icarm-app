import 'package:flutter/material.dart';

class ColorStyle {
  static final primaryColor = Color(0xFF2A2A2A); //#D90000
  static final secondaryColor = Color(0xff454FD8);
  static final thirdColor = Color(0xffA9BFE9);
  static const hintDarkColor = Color(0xFF8F9098);
  static const hintColor = Color(0xFFC5C6CC);
  static final background = Colors.white;
  static final fontColorLight = Color(0xFF656565);
  static final whiteBacground = Color(0xFFF4F5F7);
  // static final grayBackground = Color(0xFF16223A);
  static final blackBackground = Colors.white;
  static final bottomBarDark = Color(0xFF202833);
}

class TxtStyle {
  static final headerStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 23.0,
      fontWeight: FontWeight.w800,
      color: ColorStyle.primaryColor,
      letterSpacing: 1.5);

  static final headerWhiteStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 22.0,
      fontWeight: FontWeight.w800,
      color: Colors.white60,
      letterSpacing: 1.5);

  static final descriptionStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 13.0,
      color: Colors.white,
      fontWeight: FontWeight.w400);

  static final labelText = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 14,
      color: ColorStyle.primaryColor,
      fontWeight: FontWeight.bold);

  static final hintText = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 13.0,
      color: Colors.grey,
      fontWeight: FontWeight.w400);

  static final paraPrimStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 16.0,
      color: Color(0xFFD90000),
      fontWeight: FontWeight.w400);
}
