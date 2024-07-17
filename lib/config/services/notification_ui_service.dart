import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:lottie/lottie.dart';

class NotificationUI {
  NotificationUI._();

  static final instance = NotificationUI._();

  // Notification warning
  void notificationWarning(String text) {
    BotToast.showNotification(
      duration: const Duration(seconds: 4),
      backgroundColor: ColorStyle.secondaryColor,
      borderRadius: 20.0,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: const Icon(FontAwesomeIcons.circleExclamation,
              color: Colors.white)),
      title: (_) => Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }

  // Notification error
  void notificationError(String msg) {
    BotToast.showNotification(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: const Icon(FontAwesomeIcons.bug, color: Colors.white)),
      title: (_) => Text(
        msg,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.redAccent),
        onPressed: cancel,
      ),
    );
  }

  // Notification error
  void notificationAlert(String msg, String body) {
    BotToast.showNotification(
      duration: const Duration(seconds: 3),
      backgroundColor: ColorStyle.primaryColor,
      borderRadius: 12.0,
      margin: const EdgeInsets.all(15),
      leading: (cancel) => Container(
        padding: EdgeInsets.all(13),
        child: Lottie.network(
            "https://lottie.host/ad0d6333-7375-4dca-aea2-0b568e233086/YGfBEVwzt2.json",
            height: 50,
            fit: BoxFit.contain),
      ),
      title: (_) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              msg,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            Text(
              body,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }

  void notificationSuccess(String msg) {
    BotToast.showNotification(
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.green[300],
      borderRadius: 12.0,
      margin: const EdgeInsets.all(15),
      leading: (cancel) => Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(Icons.check)),
      title: (_) => Text(
        msg,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }

  // Notification No internet
  void notificationNoInternet() {
    BotToast.showNotification(
      borderRadius: 12.0,
      duration: const Duration(seconds: 7),
      backgroundColor: Colors.blueGrey,
      leading: (cancel) => SizedBox.fromSize(
          size: const Size(40, 40),
          child: const Icon(Icons.wifi_off_outlined, color: Colors.white)),
      title: (_) => const Text(
        "Verifica tu conexión a internet",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      trailing: (cancel) => IconButton(
        icon: const Icon(Icons.cancel, color: Colors.white),
        onPressed: cancel,
      ),
    );
  }

  Future<void> notificationToAcceptAction(
      BuildContext context, String msg, VoidCallback confirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: 50,
                    color: ColorStyle.secondaryColor,
                  ),
                ),
                Text(
                  msg,
                  style: const TextStyle(color: Colors.black87, fontSize: 17),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                context.pop();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(
                    color: ColorStyle.hintDarkColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: confirm,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                decoration: BoxDecoration(
                    color: ColorStyle.secondaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // Notification No internet
  void showLoading() {
    int seconds = 2;
    bool clickClose = true;
    bool allowClick = true;
    bool crossPage = true;
    int animationMilliseconds = 200;
    int animationReverseMilliseconds = 200;
    BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;
    BotToast.showLoading(
        clickClose: clickClose,
        allowClick: allowClick,
        crossPage: crossPage,
        backButtonBehavior: backButtonBehavior,
        animationDuration: Duration(milliseconds: animationMilliseconds),
        animationReverseDuration:
            Duration(milliseconds: animationReverseMilliseconds),
        duration: Duration(seconds: seconds, milliseconds: 500),
        backgroundColor: ColorStyle.primaryColor.withOpacity(0.5));
  }
}
