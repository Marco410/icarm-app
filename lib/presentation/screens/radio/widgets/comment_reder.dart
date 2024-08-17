import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer_pro/sizer.dart';

Widget renderComment(String comment) {
  return Html(
    data: comment,
    shrinkWrap: true,
    style: {
      "p": Style(
          color: Colors.white,
          fontSize: FontSize(5.sp),
          lineHeight: LineHeight(1.3),
          margin: Margins.only(bottom: 4),
          fontWeight: FontWeight.w500),
      "br": Style(
        display: Display.none,
      )
    },
  );
}
