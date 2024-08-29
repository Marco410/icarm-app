import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer_pro/sizer.dart';

Widget renderComment(String comment, Color color, double fontSize) {
  return Html(
    data: comment,
    shrinkWrap: true,
    style: {
      "p": Style(
          color: color,
          fontSize: FontSize(fontSize),
          lineHeight: LineHeight(1.3),
          margin: Margins.only(bottom: 4),
          textDecorationColor: Colors.white,
          fontWeight: FontWeight.w500),
      "br": Style(
        display: Display.none,
      ),
      "a": Style(
        display: Display.none,
      ),
      "li": Style(
        color: Colors.white,
        fontSize: FontSize(5.6.f),
        lineHeight: LineHeight(0),
        margin: Margins.only(bottom: 0),
        textDecorationColor: Colors.white,
      )
    },
  );
}
