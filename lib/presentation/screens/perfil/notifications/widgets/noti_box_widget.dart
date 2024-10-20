// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/controllers/notification_controller.dart';
import 'package:icarm/presentation/providers/notification_provider.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../../config/helpers/formats_helper.dart';
import '../../../../../config/services/notification_ui_service.dart';
import '../../../../models/NotificationModel.dart';

class NotiBoxWidget extends StatelessWidget {
  String icon;
  Color color;
  Function onTap;
  Notificacione noti;
  NotiBoxWidget({
    required this.icon,
    this.color = ColorStyle.secondaryColor,
    required this.onTap,
    required this.noti,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 0, left: 8, right: 8, top: 6),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: noti.seen == 0
              ? ColorStyle.secondaryColor.withOpacity(0.1)
              : Colors.white,
          boxShadow: (noti.seen == 0)
              ? []
              : [
                  BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: -3.0)
                ],
          borderRadius: BorderRadius.circular(8)),
      child: Material(
        color: Colors.transparent,
        child: Bounceable(
          onTap: onTap as void Function(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconNoti(
                  color: color,
                  icon: getIcon(noti.type),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(noti.title,
                          style: TxtStyle.labelText.copyWith(fontSize: 6.f)),
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          noti.body,
                          overflow: TextOverflow.ellipsis,
                          style: TxtStyle.descriptionStyle
                              .copyWith(color: Colors.black87, fontSize: 5.5.f),
                        ),
                      ),
                      SizedBox(
                        width: 60.w,
                        child: Text(
                          FormatsHelper.formatDateyMMMdh(noti.createdAt),
                          overflow: TextOverflow.ellipsis,
                          style: TxtStyle.hintText.copyWith(fontSize: 4.5.f),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: (noti.seen == 0)
                        ? const Icon(
                            Icons.circle,
                            size: 10,
                            color: ColorStyle.secondaryColor,
                          )
                        : const SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogNoti extends StatelessWidget {
  final Notificacione noti;
  final WidgetRef ref;
  final BuildContext ctx;

  const DialogNoti(
      {super.key, required this.noti, required this.ref, required this.ctx});

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    Map<String, dynamic> data;
    if (noti.data.isNotEmpty) {
      data = json.decode(noti.data);
    } else {
      data = {};
    }
    return AlertDialog(
      scrollable: true,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconNoti(
                color: ColorStyle.secondaryColor, icon: getIcon(noti.type)),
            const SizedBox(
              height: 20,
            ),
            Text(
              noti.title,
              style: TxtStyle.headerStyle.copyWith(fontSize: 8.f),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              noti.body,
              style: TxtStyle.descriptionStyle
                  .copyWith(color: Colors.black87, fontSize: 6.5.f),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              FormatsHelper.formatDateyMMMdh(noti.createdAt),
              overflow: TextOverflow.ellipsis,
              style: TxtStyle.hintText.copyWith(fontSize: 5.5.f),
            ),
            (data.isNotEmpty) ? SizedBox() : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Eliminar",
                    size: 'sm',
                    loading: loading,
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    onTap: () {
                      NotificationUI.instance.notificationToAcceptAction(
                          context, "¿Deseas eliminar está notificación?", () {
                        NotificationController.delete(noti.id.toString())
                            .whenComplete(() {
                          // ignore: unused_result
                          ref.refresh(notificationsProvider);

                          context.pop();
                          ctx.pop();
                        });
                      }, loading);
                    },
                    margin: const EdgeInsets.only(
                        bottom: 0, top: 10, left: 5, right: 5),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class IconNoti extends StatelessWidget {
  const IconNoti({
    super.key,
    required this.color,
    required this.icon,
  });

  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(0.2)),
        child: SvgPicture.asset(
          "assets/icon/$icon",
          colorFilter: const ColorFilter.mode(
              ColorStyle.secondaryColor, BlendMode.srcIn),
          height: 8.5.sp,
        ));
  }
}

String getIcon(String type) {
  const typesIcons = {
    'event': 'calendar.svg',
  };

  return typesIcons[type] ?? 'notification.svg';
}
