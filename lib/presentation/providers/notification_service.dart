import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/generated/l10n.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/services/notification_ui_service.dart';
import '../components/text_field.dart';
import '../components/zcomponents.dart';
import '../models/models.dart';

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

  static showDialogNotification(String? title, String userID,
      BuildContext context, WidgetRef ref, String? telefono) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController msgController = TextEditingController();
    FocusNode titleNode = FocusNode();
    FocusNode msgNode = FocusNode();
    bool loadingNoti = false;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (ctx, setState) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.notification_add,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Notificación",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (title == null)
                        ? TextFieldWidget(
                            border: true,
                            isRequired: false,
                            textInputType: TextInputType.text,
                            label: "Título",
                            hintText: 'Escribe aquí',
                            focusNode: titleNode,
                            controller: titleController,
                            capitalize: true,
                          )
                        : SizedBox(),
                    (title == null)
                        ? SizedBox(
                            height: 15,
                          )
                        : SizedBox(),
                    TextFieldWidget(
                      border: true,
                      isRequired: false,
                      textInputType: TextInputType.text,
                      label: "Mensaje",
                      hintText: 'Escribe aquí',
                      focusNode: msgNode,
                      controller: msgController,
                      lines: 4,
                      capitalize: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomButton(
                      margin: EdgeInsets.all(5),
                      text: "Enviar",
                      onTap: () {
                        if (msgController.text != "") {
                          setState(() {
                            loadingNoti = true;
                          });
                          // ignore: unused_result
                          ref.refresh(sendNotiUserProvider(NotiUserData(
                              title: (title != null)
                                  ? title
                                  : titleController.text,
                              msg: msgController.text,
                              userIDToSend: userID,
                              context: ctx)));

                          if (telefono != null) {
                            final Uri toLaunch = Uri(
                                scheme: 'https',
                                host: 'wa.me',
                                path: '${telefono}',
                                queryParameters: {"text": msgController.text});

                            Future.delayed(Duration(seconds: 1), () {
                              launchUrl(toLaunch,
                                  mode: LaunchMode.externalApplication);
                            });
                          }
                          Future.delayed(Duration(seconds: 1), () {
                            msgController.text = "";
                            setState(() {
                              loadingNoti = false;
                            });
                            context.pop();
                          });
                        } else {
                          NotificationUI.instance
                              .notificationWarning('Agrega un mensaje');
                        }
                      },
                      loading: loadingNoti,
                      textColor: Colors.white,
                      color: ColorStyle.primaryColor,
                    ),
                  ],
                ),
                backgroundColor: Colors.white),
          );
        },
        barrierDismissible: true);
  }
}
