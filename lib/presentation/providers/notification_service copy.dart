import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';

class NotificationService {
  static showAlertInfo(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_rounded,
                    size: 30,
                    color: ColorStyle.primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Información",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: Text(message,
                  style: const TextStyle(color: Colors.black, fontSize: 15)),
              backgroundColor: Colors.white);
        },
        barrierDismissible: true);
  }
}
