import 'dart:convert';

import 'package:icarm/config/setting/api.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../providers/auth_service.dart';

class KidsController {
  KidsController._instance();

  static Future<bool> generateCode(
      {required String usuarioID,
      required String code,
      required String kid_id}) async {
    final Map<String, String> codeData = {
      "user_id": usuarioID,
      "code": code,
      "kid_id": kid_id
    };

    String decodedResp = await BaseHttpService.basePost(
        url: GENERATE_CODE_KID, authorization: true, body: codeData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance.notificationWarning(
            'No pudimos completar la operación, inténtelo más tarde. ${resp["description"]["message"]}');

        return false;
      }
    }

    return true;
  }

  static Future<bool> invalidarCode({required String kid_id}) async {
    final Map<String, String> codeData = {"kid_id": kid_id};

    String decodedResp = await BaseHttpService.basePost(
        url: INVALIDAR_CODE_KID, authorization: true, body: codeData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance.notificationWarning(
            'No pudimos completar la operación, inténtelo más tarde.');

        return false;
      }
    }

    return true;
  }

  static Future<bool> validarCode({required String code}) async {
    final Map<String, String> codeData = {
      "tutor_id": prefs.usuarioID,
      "code": code
    };

    String decodedResp = await BaseHttpService.basePost(
        url: VALIDAR_CODE_KID, authorization: true, body: codeData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess(resp["message"]);
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning(resp["description"]["message"]);

        return false;
      }
    }

    return true;
  }

  static Future<bool> registerKid(
      {required String nombre,
      required String a_paterno,
      required String a_materno,
      required String fecha_nacimiento,
      required String sexo,
      required String enfermedad}) async {
    final Map<String, dynamic> registerKid = {
      "user_id": prefs.usuarioID,
      "nombre": nombre,
      "a_paterno": a_paterno,
      "a_materno": a_materno,
      "fecha_nacimiento": fecha_nacimiento,
      "sexo": sexo,
      "enfermedad": enfermedad,
    };

    String decodedResp = "";

    decodedResp = await BaseHttpService.basePost(
        url: REGISTER_KID_URL, authorization: true, body: registerKid);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess(
            '${sexo == 'Hombre' ? 'Tu hijo ha sido registrado' : 'Tu hija ha sido registrada'} con éxito.');

        return true;
      } else {
        NotificationUI.instance.notificationWarning(
            'No pudimos completar la operación, inténtelo más tarde.');
        return false;
      }
    }
    return false;
  }

  static Future<bool> updateKid(
      {required String nombre,
      required String kid_id,
      required String a_paterno,
      required String a_materno,
      required String fecha_nacimiento,
      required String sexo,
      required String enfermedad}) async {
    final Map<String, dynamic> registerKid = {
      "kid_id": kid_id,
      "nombre": nombre,
      "a_paterno": a_paterno,
      "a_materno": a_materno,
      "fecha_nacimiento": fecha_nacimiento,
      "sexo": sexo,
      "enfermedad": enfermedad,
    };

    String decodedResp = "";

    decodedResp = await BaseHttpService.basePut(
        url: UPDATE_KID_URL, authorization: true, body: registerKid);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess(
            '${sexo == 'Hombre' ? 'Tu hijo ha sido actualizado' : 'Tu hija ha sido actualizada'} con éxito.');
        return true;
      } else {
        NotificationUI.instance.notificationWarning(
            'No pudimos completar la operación, inténtelo más tarde.');
        return false;
      }
    }
    return false;
  }
}
