import 'package:flutter/material.dart';
import 'package:sizer_pro/sizer.dart';

class ColorStyle {
  static const primaryColor = Color(0xFF1A2228);
  static const secondaryColor = Color(0xff454FD8);
  static const thirdColor = Color(0xffA9BFE9);
  static const hintDarkColor = Color(0xFF8F9098);
  static const hintColor = Color(0xFFC5C6CC);
  static const hintLightColor = Color(0xFFE0E0E0);
  static const background = Colors.white;
  static const bible = Color(0xFF2A60FF);
  static const alert = Color(0xFFF85046);
  static const fontColorLight = Color(0xFF656565);
  static const whiteBacground = Color(0xFFF4F5F7);
  // static const grayBackground = Color(0xFF16223A);
  static const blackBackground = Colors.white;
  static const bottomBarDark = Color(0xFF202833);
}

class TxtStyle {
  static final headerStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 9.f,
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
      fontSize: 6.f,
      color: Colors.white,
      fontWeight: FontWeight.w400);

  static final labelText = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 6.f,
      color: ColorStyle.primaryColor,
      fontWeight: FontWeight.bold);

  static final hintText = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 5.f,
      color: Colors.grey,
      fontWeight: FontWeight.w400);

  static final paraPrimStyle = TextStyle(
      fontFamily: "Montserrat",
      fontSize: 16.0,
      color: Color(0xFFD90000),
      fontWeight: FontWeight.w400);
}

class ShadowStyle {
  static final boxShadow = [
    BoxShadow(
      color: Color(0x26AAA9A9),
      blurRadius: 8,
      offset: Offset(0, 6),
      spreadRadius: 2,
    )
  ];
}
