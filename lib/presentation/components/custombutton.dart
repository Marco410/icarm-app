// ignore_for_file: must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:sizer_pro/sizer.dart';

import '../../config/setting/style.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final Function? onTap;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  bool loading = false;
  String? size = 'md';

  CustomButton(
      {super.key,
      required this.text,
      this.color,
      this.textColor,
      required this.onTap,
      this.width,
      this.margin,
      required this.loading,
      this.size,
      this.borderRadius});
  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: (loading) ? () => {} : onTap as void Function()?,
      child: FadedScaleAnimation(
        child: Container(
          width: width ?? double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: (size == 'sm') ? 4.sp : 5.sp,
              horizontal: (size == 'sm') ? 4.sp : 5.sp),
          margin: margin ?? const EdgeInsets.all(32),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: -3,
                    offset: Offset(0, 0))
              ],
              color: color ?? ColorStyle.primaryColor,
              borderRadius: borderRadius ?? BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (loading)
                  ? SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color:
                            ((color ?? ColorStyle.primaryColor) == Colors.white)
                                ? ColorStyle.secondaryColor
                                : Colors.white,
                      ),
                    )
                  : Text(
                      text!,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: (size == 'sm') ? 4.sp : 5.sp),
                      textAlign: TextAlign.center,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
