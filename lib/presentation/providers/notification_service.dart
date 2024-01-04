import 'package:flutter/material.dart';
import 'package:icarm/config/generated/l10n.dart';
import 'package:icarm/config/setting/style.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerkey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackBarError(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(S.of(context)!.success),
              content: Text(message,
                  style: TextStyle(color: Colors.white, fontSize: 19)),
              backgroundColor: Colors.red);
        },
        barrierDismissible: true);
  }

  static showSnackBarSuccess(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(S.of(context)!.success),
            content: Text(message,
                style: TextStyle(color: Colors.white, fontSize: 19)),
            backgroundColor: Colors.green,
          );
        },
        barrierDismissible: true);
    /* final snackBar = new SnackBar(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))),
      content:
          Text(message, style: TextStyle(color: Colors.green, fontSize: 19)),
    );

    messengerkey.currentState.showSnackBar(snackBar); */
  }

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
