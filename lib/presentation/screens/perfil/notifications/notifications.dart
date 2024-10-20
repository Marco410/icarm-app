// ignore_for_file: use_build_context_synchronously

import 'package:flutter/Material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/controllers/notification_controller.dart';
import 'package:icarm/presentation/providers/notification_provider.dart';
import 'package:icarm/presentation/screens/perfil/notifications/widgets/noti_box_widget.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notis = ref.watch(notificationsProvider);
    final listNotis = ref.watch(listNotificationsProvider);
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (listNotis.isNotEmpty && listNotis.any((n) => n.seen == 0))
                      ? Bounceable(
                          onTap: () {
                            NotificationUI.instance.notificationToAcceptAction(
                                context, "Se marcarán como leídas.", () {
                              NotificationController.seeAll().whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                                _refresh();
                                if (mounted) {
                                  context.pop();
                                }
                              });
                            }, loading);
                          },
                          child: Text(
                            "Marcar como leídas",
                            style: TxtStyle.labelText.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor: ColorStyle.hintDarkColor,
                                color: ColorStyle.hintDarkColor),
                          ),
                        )
                      : SizedBox(),
                  (listNotis.isNotEmpty)
                      ? IconButton(
                          onPressed: () {
                            NotificationUI.instance.notificationToAcceptAction(
                                context,
                                "¿Deseas borrar todas tus notificaciones?", () {
                              NotificationController.deleteAll()
                                  .whenComplete(() {
                                setState(() {
                                  loading = false;
                                });
                                _refresh();
                                if (mounted) {
                                  context.pop();
                                }
                              });
                            }, loading);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 10.f,
                          ))
                      : SizedBox()
                ],
              ),
              Container(
                  height: 90.h,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 60),
                  child: notis.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                              child: LoadingStandardWidget.loadingNoDataWidget(
                                  'notificaciones')),
                        );
                      }

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 40),
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(12)),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) {
                                NotificationUI.instance
                                    .notificationToAcceptAction(context,
                                        "¿Quieres eliminar esta notificación?",
                                        () {
                                  NotificationController.delete(
                                          data[index].id.toString())
                                      .whenComplete(() {
                                    setState(() {
                                      loading = false;
                                    });
                                    _refresh();
                                    if (mounted) {
                                      context.pop();
                                    }
                                  });
                                }, loading);
                                return Future.value(false);
                              },
                              movementDuration:
                                  const Duration(milliseconds: 50),
                              resizeDuration: const Duration(milliseconds: 50),
                              dismissThresholds: const {
                                DismissDirection.startToEnd: 0.1
                              },
                              key: Key(data[index].id.toString()),
                              child: NotiBoxWidget(
                                icon: "notification.svg",
                                noti: data[index],
                                onTap: () {
                                  if (data[index].seen == 0) {
                                    setState(() {
                                      data[index].seen = 1;
                                    });
                                    NotificationController.seen(
                                            data[index].id.toString())
                                        .whenComplete(() {
                                      _refresh();
                                    });
                                  }

                                  showDialog(
                                      context: context,
                                      builder: (context) => DialogNoti(
                                            noti: data[index],
                                            ctx: context,
                                            ref: ref,
                                          ));
                                },
                              ),
                            );
                          });
                    },
                    error: (error, stackTrace) {
                      return Center(
                          child: LoadingStandardWidget.loadingErrorWidget());
                    },
                    loading: () =>
                        Center(child: LoadingStandardWidget.loadingWidget()),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    // ignore: unused_result
    ref.refresh(notificationsProvider);
  }
}
