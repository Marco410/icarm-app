// ignore_for_file: use_build_context_synchronously, unused_result, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/api.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/share_prefs/prefs_usuario.dart';
import '../models/kids/TeacherModel.dart';
import '../models/kids/kidModels.dart';
import '../models/kids/kidsInClassModel.dart';

const storage = FlutterSecureStorage();
final prefs = PreferenciasUsuario();

final updateKidProvider = StateProvider<bool>((ref) {
  return false;
});

final registerKidTeacherProvider =
    FutureProvider.family<void, KidRegisterTeacherData>((ref, data) async {
  final Map<String, dynamic> registerKid = {
    "user_id": prefs.usuarioID,
    "kid_id": data.kid_id
  };

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePost(
      url: REGISTER_TEACHER_KID_URL, authorization: true, body: registerKid);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess('Niño agregado con éxito');
      data.context.pop();

      ref.refresh(getKidsInClassroomProvider(prefs.usuarioID));
    } else {
      if (resp['description'] != null) {
        return NotificationUI.instance
            .notificationWarning("Alerta:" + resp['description']['message']);
      }

      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});

final getKidsInClassroomProvider = FutureProvider.family
    .autoDispose<List<Classroom>, String>((ref, userID) async {
  final Map<String, String> getKids = {
    "user_id": userID,
  };

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_KIDS_IN_CLASS_URL, authorization: true, params: getKids);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      KidsInClassModel listKids = kidsInClassModelFromJson(decodedResp);
      return listKids.data;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final exitClassProvider =
    FutureProvider.family<void, ExitClassData>((ref, data) async {
  final Map<String, dynamic> registerKid = {"class_id": data.class_id};

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePost(
      url: EXIT_CLASS_URL, authorization: true, body: registerKid);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess('Niño entregado con éxito');
      data.context.pop();

      ref.refresh(getKidsInClassroomProvider(prefs.usuarioID));
    } else {
      if (resp['description'] != null) {
        return NotificationUI.instance
            .notificationWarning("Alerta:" + resp['description']['message']);
      }

      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});

final getTeacherListProvider =
    FutureProvider.autoDispose<List<Teacher>>((ref) async {
  final Map<String, String> getKids = {};

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_TEACHERS, authorization: true, params: getKids);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      TeachersModel listKids = teachersModelFromJson(decodedResp);

      List<bool> listOpens = [];

      for (var teacher in listKids.teachers) {
        listOpens.add(false);
      }

      ref.read(openTeacherProvider.notifier).update((state) => listOpens);

      return listKids.teachers;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final openTeacherProvider = StateProvider<List<bool>>((ref) {
  return [];
});
