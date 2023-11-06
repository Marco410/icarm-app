// ignore_for_file: unused_result

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:intl/intl.dart';

import '../../../components/zcomponents.dart';
import '../../../providers/notification_provider.dart';

class NotiPreviewPage extends ConsumerStatefulWidget {
  const NotiPreviewPage();

  @override
  ConsumerState<NotiPreviewPage> createState() => _NotiPreviewPageState();
}

class _NotiPreviewPageState extends ConsumerState<NotiPreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    final notiSelected = ref.watch(notiSelectedGetProvider);
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: (notiSelected.length == 0)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FadedSlideAnimation(
              child: Container(
                padding: EdgeInsets.all(17),
                margin: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        notiSelected[0]['title'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorStyle.secondaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        notiSelected[0]['body'].toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        DateFormat.yMMMEd('es_MX').format(DateTime.parse(
                            notiSelected[0]['sentTime'].toString())),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          NotificationUI.instance.notificationToAcceptAction(
                              context,
                              "¿Estás seguro de eliminar esta notificación?",
                              () {
                            ref.refresh(deleteNotiProvider(
                                notiSelected[0]['id'].toString()));
                            context.pop();
                            context.pop();
                          });

                          /* NotificationService.showSnackBarDeleteNoti(
                              "¿Estás seguro de eliminar esta notificación?",
                              notiSelected[0]['id'].toString(),
                              context); */
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red[300],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
    );
  }
}
