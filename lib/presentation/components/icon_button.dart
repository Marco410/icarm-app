import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:icarm/config/setting/style.dart';

class IconButtonWidget extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final Color iconColor;
  final IconData icon;
  final bool selected;
  const IconButtonWidget(
      {super.key,
      required this.onTap,
      required this.color,
      required this.iconColor,
      required this.icon,
      this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(right: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (selected) ? ColorStyle.secondaryColor : color),
          child: Icon(
            icon,
            color: (selected) ? Colors.white : iconColor,
          )),
    );
  }
}
