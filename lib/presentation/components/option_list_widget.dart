import 'package:flutter/Material.dart';
import 'package:icarm/config/setting/style.dart';

class OptionListWidget extends StatelessWidget {
  const OptionListWidget({
    super.key,
    required this.selected,
    required this.text,
  });

  final bool selected;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: (selected)
              ? ColorStyle.primaryColor
              : ColorStyle.secondaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: ColorStyle.secondaryColor,
            size: 10,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: TxtStyle.labelText.copyWith(
                fontSize: 13,
                color: (selected) ? Colors.white : Colors.black87),
          ),
        ],
      ),
    );
  }
}
