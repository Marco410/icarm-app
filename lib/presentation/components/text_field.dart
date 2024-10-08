// ignore_for_file: unnecessary_string_escapes, must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:sizer_pro/sizer.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? suffixText;
  final IconButton? suffixIcon;
  final EdgeInsets? margin;
  final IconData? prefixIcon;
  final Color? color;
  final String? label;
  final Color? labelColor;
  final bool border;
  final Function? onTap;
  final bool isVisible;
  final int? lines;
  TextEditingController? controller = TextEditingController();
  TextInputType textInputType;
  bool isRequired;
  final bool? readOnly;
  final Widget? iconField;
  final FocusNode? focusNode;
  final Function? onEditingComplete;
  final bool capitalize;
  final String? autoFillHints;
  final Function? onTyping;

  TextFieldWidget(
      {super.key,
      this.hintText,
      this.suffixText,
      this.isVisible = true,
      this.label,
      this.labelColor,
      required this.border,
      this.suffixIcon = null,
      this.margin,
      this.prefixIcon,
      this.color,
      this.onTap,
      this.controller,
      this.lines,
      this.readOnly = false,
      this.iconField,
      this.focusNode,
      this.onEditingComplete,
      this.capitalize = false,
      this.autoFillHints = "",
      this.onTyping,
      required this.isRequired,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FadedScaleAnimation(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (label != null)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                  child: Text(
                    '$label ${(isRequired) ? "*" : ""}',
                    style: TextStyle(
                        color: labelColor ?? Colors.black87,
                        fontSize: 4.5.sp,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox(),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                right: 15,
                left: 16,
                top: (suffixIcon != null) ? 10 : 3,
                bottom: (suffixIcon != null) ? 0 : 3),
            decoration: BoxDecoration(
                color: color ?? Colors.white,
                border: border
                    ? Border.all(color: ColorStyle.hintColor, width: 0.3)
                    : Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
                boxShadow: ShadowStyle.boxShadow),
            child: TextFormField(
              autofillHints: [autoFillHints ?? ""],
              readOnly: readOnly! || TextInputType.datetime == textInputType,
              autofocus: false,
              controller: controller,
              keyboardType: textInputType,
              style: TextStyle(
                  color: (readOnly! && TextInputType.datetime != textInputType)
                      ? Colors.grey
                      : Colors.black,
                  fontSize: 5.3.sp),
              onTap: onTap as void Function()?,
              maxLines: lines ?? 1,
              textInputAction: TextInputAction.done,
              textCapitalization: (textInputType == TextInputType.emailAddress)
                  ? TextCapitalization.none
                  : (capitalize)
                      ? TextCapitalization.sentences
                      : TextCapitalization.words,
              validator: (input) {
                if (textInputType == TextInputType.emailAddress) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);
                  if (isRequired) {
                    if (input!.isEmpty) {
                      return "Requerido";
                    }
                    if (regExp.hasMatch(input)) {
                      return null;
                    } else {
                      return "Correo electrónico inválido";
                    }
                  }
                } else if (textInputType == TextInputType.text) {
                  if (isRequired) {
                    if (input!.isEmpty) {
                      return "Requerido";
                    }
                  }

                  if (label == 'CURP') {
                    if (input!.isNotEmpty) {
                      String pattern =
                          r"^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)$";
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(input)
                          ? null
                          : "Inserte una curp valida";
                    }
                  }
                } else if (textInputType == TextInputType.number) {
                  if (isRequired) {
                    if (input!.isEmpty) {
                      return "Requerido";
                    }
                    if (input.length != 10 && label != 'Edad') {
                      return "Debe de ser de 10 dígitos";
                    }
                  }
                }
                return null;
              },
              obscureText: !isVisible,
              focusNode: focusNode,
              onChanged: onTyping as void Function(String)?,
              onEditingComplete: (onEditingComplete != null)
                  ? onEditingComplete as void Function()
                  : () {},
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle:
                      TextStyle(color: ColorStyle.hintDarkColor, fontSize: 13),
                  enabledBorder: InputBorder.none,
                  suffixStyle: theme.textTheme.titleSmall!.copyWith(
                    color: theme.primaryColor,
                  ),
                  suffixIcon: (suffixIcon != null)
                      ? Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(bottom: 10),
                          height: 10,
                          width: 10,
                          child: suffixIcon)
                      : null,
                  focusColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
