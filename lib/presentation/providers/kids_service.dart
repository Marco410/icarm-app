// ignore_for_file: use_build_context_synchronously, unused_result, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/models/kids/kidsModel.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/share_prefs/prefs_usuario.dart';
import '../models/models.dart';

const storage = FlutterSecureStorage();
final prefs = PreferenciasUsuario();

final updateKidProvider = StateProvider<bool>((ref) {
  return false;
});

final getKidsProvider =
    FutureProvider.family<List<Kid>?, String>((ref, userID) async {
  final Map<String, String> getKids = {
    "user_id": userID,
  };

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_KIDS_URL, authorization: true, params: getKids);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      KidsModel listKids = kidsModelFromJson(decodedResp);
      return listKids.data.kids;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final registerKid =
    FutureProvider.family<void, KidRegisterData>((ref, kidRegister) async {
  final Map<String, dynamic> registerKid = {
    "user_id": prefs.usuarioID,
    "nombre": kidRegister.nombre,
    "a_paterno": kidRegister.a_paterno,
    "a_materno": kidRegister.a_materno,
    "fecha_nacimiento": kidRegister.fecha_nacimiento,
    "sexo": kidRegister.sexo,
    "enfermedad": kidRegister.enfermedad,
  };

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePost(
      url: REGISTER_KID_URL, authorization: true, body: registerKid);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess('Hij@ registrado con éxito.');

      kidRegister.context.pop();
      ref.refresh(getKidsProvider(prefs.usuarioID));
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});

final update_kid =
    FutureProvider.family<void, KidRegisterData>((ref, kidRegister) async {
  final Map<String, dynamic> registerKid = {
    "kid_id": kidRegister.kid_id,
    "nombre": kidRegister.nombre,
    "a_paterno": kidRegister.a_paterno,
    "a_materno": kidRegister.a_materno,
    "fecha_nacimiento": kidRegister.fecha_nacimiento,
    "sexo": kidRegister.sexo,
    "enfermedad": kidRegister.enfermedad,
  };

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePut(
      url: UPDATE_KID_URL, authorization: true, body: registerKid);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance
          .notificationSuccess('Hij@ actualizado con éxito.');

      kidRegister.context.pop();

      ref.refresh(getKidsProvider(prefs.usuarioID));
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});

final delete_kid =
    FutureProvider.family<void, KidRegisterData>((ref, kidID) async {
  final Map<String, String> deleteKid = {"kid_id": kidID.kid_id.toString()};

  String decodedResp = await BaseHttpService.baseGet(
      url: DELETE_KID_URL, authorization: true, params: deleteKid);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess('Hij@ eliminado con éxito.');

      kidID.context.pop();

      ref.refresh(getKidsProvider(prefs.usuarioID));
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});
