// ignore_for_file: unnecessary_string_escapes, must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';

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

  TextFieldWidget(
      {super.key,
      this.hintText,
      this.suffixText,
      this.isVisible = true,
      this.label,
      this.labelColor,
      required this.border,
      this.suffixIcon,
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
                        fontWeight: FontWeight.bold),
                  ),
                )
              : const SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: color ?? Colors.white,
              border: border
                  ? Border.all(color: ColorStyle.hintColor)
                  : Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              readOnly: readOnly!,
              autofocus: false,
              controller: controller,
              keyboardType: textInputType,
              style: TextStyle(
                  color: (readOnly!)
                      ? (textInputType == TextInputType.datetime)
                          ? Colors.black
                          : Colors.grey
                      : Colors.black),
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
                    if (input.length != 10) {
                      return "Debe de ser de 10 dígitos";
                    }
                  }
                }
                return null;
              },
              obscureText: !isVisible,
              focusNode: focusNode,
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
                  suffixIcon: suffixIcon,
                  focusColor: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
