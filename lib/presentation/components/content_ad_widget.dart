import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';

class ContentAdWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String? buttonText;
  final Function? actionButton;
  const ContentAdWidget(
      {super.key,
      required this.image,
      required this.title,
      this.buttonText,
      this.actionButton,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              fit: BoxFit.fitWidth,
              image: AssetImage(image))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            subTitle,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(
            height: 30,
          ),
          (buttonText != null)
              ? InkWell(
                  onTap: actionButton! as void Function(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      buttonText!,
                      style: TextStyle(
                          color: ColorStyle.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
