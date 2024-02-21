// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_result
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/services/notification_ui_service.dart';
import '../../../config/setting/style.dart';
import '../../models/kids/TeacherModel.dart';
import '../../models/models.dart';
import '../../providers/teacher_kids_provider.dart';
import '../zcomponents.dart';

Future<void> DataKid(
    BuildContext context, WidgetRef ref, Classroom kidClass) async {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: ((ctx, setState) => Container(
                height: MediaQuery.of(ctx).size.height * 0.7,
                color: const Color(0xFF737373),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  height: MediaQuery.of(ctx).size.height * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Información de:",
                        style: TxtStyle.headerStyle
                            .copyWith(color: Colors.black87, fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: -3,
                                offset: Offset(0, 0))
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              (kidClass.kid.sexo == 'Hombre')
                                  ? Icons.face_rounded
                                  : Icons.face_2_rounded,
                              color: ColorStyle.secondaryColor,
                              size: 70,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "${kidClass.kid.nombre} ${kidClass.kid.aPaterno} ${kidClass.kid.aMaterno}",
                              textAlign: TextAlign.center,
                              style: TxtStyle.headerStyle.copyWith(
                                  color: ColorStyle.secondaryColor,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Padre o tutor:",
                        style: TxtStyle.headerStyle.copyWith(
                            color: ColorStyle.primaryColor, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${kidClass.kid.user.nombre} ${kidClass.kid.user.apellidoPaterno} ${kidClass.kid.user.apellidoMaterno}",
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(
                            color: ColorStyle.primaryColor, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CustomButton(
                            text: "Llamar",
                            onTap: () {
                              final Uri launchUri = Uri(
                                scheme: 'tel',
                                path: kidClass.kid.user.telefono,
                              );
                              launchUrl(launchUri);
                            },
                            loading: false,
                            textColor: Colors.white,
                            color: ColorStyle.secondaryColor,
                            margin: EdgeInsets.all(5),
                          )),
                          Expanded(
                              child: CustomButton(
                            margin: EdgeInsets.all(5),
                            text: "Enviar notificación",
                            onTap: () =>
                                NotificationService.showDialogNotification(
                                    "Ministerios de niños",
                                    kidClass.kid.user.id.toString(),
                                    context,
                                    ref,
                                    kidClass.kid.user.telefono),
                            loading: false,
                            textColor: Colors.white,
                            color: ColorStyle.secondaryColor,
                          )),
                        ],
                      ),
                      CustomButton(
                        margin: EdgeInsets.all(5),
                        text: "Notificar a video",
                        onTap: () => NotificationService.showDialogNotification(
                            "Ministerios de niños",
                            USER_ICARM_VIDEO,
                            context,
                            ref,
                            null),
                        loading: false,
                        textColor: Colors.white,
                        color: ColorStyle.secondaryColor,
                      ),
                      CustomButton(
                        margin: EdgeInsets.all(5),
                        text: "Dar salida del salón",
                        onTap: () {
                          NotificationUI.instance.notificationToAcceptAction(
                              context, "¿Estás seguro de darle salida?", () {
                            ref.refresh(exitClassProvider(ExitClassData(
                                class_id: kidClass.id.toString(),
                                context: context)));

                            context.pop();
                          });
                        },
                        loading: false,
                        textColor: Colors.white,
                        color: ColorStyle.primaryColor,
                      ),
                      CustomButton(
                        margin: EdgeInsets.only(
                            bottom: 0, left: 60, right: 60, top: 20),
                        loading: false,
                        text: "Cancelar",
                        textColor: Colors.white,
                        color: ColorStyle.hintColor,
                        onTap: () {
                          ctx.pop();
                        },
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              )));
    },
  );
}
