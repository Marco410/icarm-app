import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/drawer.dart';

class SubAccordionWidget extends StatelessWidget {
  final bool active;
  final String title;
  final String text;
  final String image;
  final Function onTap;
  final Function onTapContent;
  const SubAccordionWidget({
    required this.active,
    required this.title,
    required this.text,
    required this.image,
    required this.onTap,
    required this.onTapContent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function(),
      child: Container(
        padding: EdgeInsets.only(
            left: 15, right: 15, top: (active) ? 15 : 5, bottom: 10),
        margin: EdgeInsets.only(top: (active) ? 10 : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular((active) ? 15 : 8),
              bottomRight: Radius.circular((active) ? 15 : 8)),
          border: Border(
            top: BorderSide(color: Colors.black54, width: (active) ? 0.3 : 0),
            right: BorderSide(color: Colors.black54, width: (active) ? 0.3 : 0),
            left: BorderSide(color: Colors.black54, width: (active) ? 0.3 : 0),
            bottom: BorderSide(
              color: Colors.black54,
              width: 0.3,
            ),
          ),
        ),
        child: Column(
          children: [
            (active)
                ? FadedSlideAnimation(
                    endOffset: Offset(0, 0),
                    beginOffset: Offset(0, 0.03),
                    child: GestureDetector(
                      onTap: onTapContent as void Function(),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/image/${image}",
                            scale: 1.1,
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderTextWidget(title: title, text: text),
                Icon(
                  (active)
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.keyboard_arrow_down,
                  size: (active) ? 25 : 35,
                  color: (active)
                      ? ColorStyle.primaryColor
                      : ColorStyle.hintDarkColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
