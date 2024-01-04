import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';

class AccordionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isOpen;
  final Widget content;
  const AccordionWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.content,
      required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: ColorStyle.hintDarkColor, width: 0.2),
                  bottom: BorderSide(
                      color: ColorStyle.hintDarkColor,
                      width: (isOpen) ? 0 : 0.2),
                  left: BorderSide(color: ColorStyle.hintDarkColor, width: 0.2),
                  right:
                      BorderSide(color: ColorStyle.hintDarkColor, width: 0.2)),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular((isOpen) ? 0 : 15),
                  bottomRight: Radius.circular((isOpen) ? 0 : 15))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TxtStyle.headerStyle
                        .copyWith(color: ColorStyle.primaryColor, fontSize: 17),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    style: TxtStyle.hintText,
                  ),
                ],
              ),
              InkWell(
                child: Icon(
                  (isOpen)
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_sharp,
                  size: 33,
                  color: (isOpen)
                      ? ColorStyle.primaryColor
                      : ColorStyle.hintDarkColor,
                ),
              )
            ],
          ),
        ),
        (isOpen)
            ? FadedSlideAnimation(
                endOffset: Offset(0, 0),
                beginOffset: Offset(0, -0.03),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular((isOpen) ? 0 : 15),
                        topRight: Radius.circular((isOpen) ? 0 : 15)),
                    border: Border(
                        bottom: BorderSide(
                            color: ColorStyle.hintDarkColor, width: 0.2),
                        top: BorderSide(
                            color: ColorStyle.hintDarkColor, width: 0.2),
                        left: BorderSide(
                            color: ColorStyle.hintDarkColor, width: 0.2),
                        right: BorderSide(
                            color: ColorStyle.hintDarkColor, width: 0.2)),
                  ),
                  child: content,
                ),
              )
            : SizedBox()
      ],
    );
  }
}
