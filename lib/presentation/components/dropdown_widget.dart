import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';

class DropdownWidget extends StatelessWidget {
  const DropdownWidget(
      {Key? key,
      required this.title,
      required this.option,
      this.subOption,
      required this.onTapFunction,
      this.readOnly = false,
      required this.isRequired})
      : super(key: key);

  final String title;
  final Option option;
  final SubOption? subOption;
  final Function onTapFunction;
  final bool isRequired;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return FormField(validator: ((value) {
      if (isRequired) {
        if (option.id == 0) {
          return "Requerido";
        }
      }
      return null;
    }), builder: (formField) {
      return FadedScaleAnimation(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Text(
                '$title ${(isRequired) ? "*" : ""}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: (readOnly) ? () {} : onTapFunction as void Function(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorStyle.hintColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (subOption != null && subOption!.id != 0)
                            ? subOption!.name
                            : option.name,
                        style: TextStyle(
                            color: (option.id == 0)
                                ? ColorStyle.hintColor
                                : (readOnly)
                                    ? Colors.grey
                                    : ColorStyle.primaryColor),
                      ),
                    ),
                    const Icon(
                      Icons.expand_more_rounded,
                      color: ColorStyle.hintDarkColor,
                    )
                  ],
                ),
              ),
            ),
            (formField.hasError)
                ? Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      formField.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      );
    });
  }
}
