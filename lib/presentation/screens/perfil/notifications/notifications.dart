// ignore_for_file: unused_result

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:intl/intl.dart';

import '../../../components/zcomponents.dart';
import '../../../providers/notification_provider.dart';

class Notifications extends ConsumerStatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class NotificationList {
  final String? message;
  final String time;

  NotificationList(this.message, this.time);
}

class _NotificationsState extends ConsumerState<Notifications> {
  @override
  Widget build(BuildContext context) {
    ref.watch(getNotiListProvider);
    final listNotis = ref.watch(notiListProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: FadedSlideAnimation(
        child: Stack(
          children: [
            (listNotis.isEmpty)
                ? Center(
                    child: LoadingStandardWidget.loadingNoDataWidget(
                        "notificaciones"),
                  )
                : ListView.builder(
                    itemCount: listNotis.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Map<String, Object?> noti = listNotis[index];

                      return InkWell(
                        onTap: () {
                          print("noti");
                          print(noti);
                          ref.refresh(
                              notiSelectedProvider(noti['id'].toString()));

                          context.pushNamed("notiPreview");
                        },
                        child: FadedScaleAnimation(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ColorStyle.whiteBacground,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: -4,
                                    offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      margin: EdgeInsets.only(right: 20),
                                      padding: EdgeInsets.all(15),
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: ColorStyle.whiteBacground,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Image.asset(
                                        "assets/image/logo.png",
                                        scale: 6,
                                      )),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            noti['title'].toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            noti['body'].toString(),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Text(
                                            DateFormat.yMMMd('es_MX').format(
                                                DateTime.parse(noti['sentTime']
                                                    .toString())),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                (noti['seen'].toString() != "0")
                                    ? Expanded(flex: 1, child: SizedBox())
                                    : Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.circle,
                                          size: 13,
                                          color: ColorStyle.secondaryColor,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
