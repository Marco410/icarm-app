// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_result
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/models/UsuarioModel.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/services/notification_ui_service.dart';
import '../../../config/setting/style.dart';
import '../../models/kids/TeacherModel.dart';
import '../../models/models.dart';
import '../../providers/teacher_kids_provider.dart';
import '../zcomponents.dart';

Future<void> DataKid(BuildContext context, WidgetRef ref, Classroom kidClass,
    Function? onExitKidFromClass()) async {
  return showModalBottomSheet<void>(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      User tutorSelected = kidClass.kid.user;
      return StatefulBuilder(builder: ((ctx, setState) {
        return Container(
          height: 90.h,
          color: const Color(0xFF737373),
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            height: MediaQuery.of(ctx).size.height * 0.9,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Información",
                    style: TxtStyle.headerStyle
                        .copyWith(color: Colors.black87, fontSize: 8.sp),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
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
                          height: 10,
                        ),
                        Text(
                          "${kidClass.kid.nombre} ${kidClass.kid.aPaterno} ${kidClass.kid.aMaterno}",
                          textAlign: TextAlign.center,
                          style: TxtStyle.headerStyle.copyWith(
                              color: ColorStyle.secondaryColor, fontSize: 8.sp),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  kidClass.kid.tutors.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              "Selecciona un tutor en caso que no te conteste el responsable:",
                              textAlign: TextAlign.center,
                              style: TxtStyle.hintText.copyWith(
                                  color: Colors.blue[400],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 35,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: kidClass.kid.tutors.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(
                                      () {
                                        if (tutorSelected !=
                                            kidClass.kid.tutors[index].user) {
                                          tutorSelected =
                                              kidClass.kid.tutors[index].user;
                                        } else {
                                          tutorSelected = kidClass.kid.user;
                                        }
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    decoration: BoxDecoration(
                                        color: (tutorSelected.id ==
                                                kidClass
                                                    .kid.tutors[index].user.id)
                                            ? Colors.grey
                                            : Colors.green[400],
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      kidClass.kid.tutors[index].user.nombre,
                                      style: TxtStyle.labelText.copyWith(
                                          fontSize: 5.5.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Responsable:",
                        style: TxtStyle.headerStyle.copyWith(
                            color: ColorStyle.primaryColor, fontSize: 16),
                      ),
                      (tutorSelected != kidClass.kid.user)
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  tutorSelected = kidClass.kid.user;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red[400],
                                ),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${tutorSelected.nombre} ${tutorSelected.apellidoPaterno} ${tutorSelected.apellidoMaterno}",
                    textAlign: TextAlign.center,
                    style: TxtStyle.headerStyle
                        .copyWith(color: ColorStyle.primaryColor, fontSize: 20),
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
                            path: tutorSelected.telefono,
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
                        onTap: () => NotificationService.showDialogNotification(
                            "Ministerios de niños",
                            tutorSelected.id.toString(),
                            context,
                            ref,
                            tutorSelected.telefono),
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
                        onExitKidFromClass();
                        context.pop();
                      }, false);
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
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        );
      }));
    },
  );
}
