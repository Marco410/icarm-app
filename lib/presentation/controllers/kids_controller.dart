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
}
