import 'package:flutter/material.dart';

import '../../config/setting/style.dart';

class CheckBoxWidget extends StatelessWidget {
  final String text;
  final bool value;
  final Function onChange;
  final bool readOnly;
  const CheckBoxWidget(
      {super.key,
      required this.text,
      required this.value,
      required this.onChange,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          activeColor: (readOnly) ? Colors.grey : ColorStyle.secondaryColor,
          onChanged: (value) => (readOnly) ? () {} : onChange(value),
        ),
        Expanded(
          child: Text(text),
        )
      ],
    );
  }
}
