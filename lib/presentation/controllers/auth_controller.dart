import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';

import '../../config/services/http_general_service.dart';

class AuthController {
  AuthController._instance();

  static Future<bool> forgotPass(String email, WidgetRef ref) async {
    final Map<String, dynamic> authData = {
      "email": email,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: FORGOT_PASS, authorization: false, body: authData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);

      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess('${resp['message']}');
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning('${resp['description']['message']}');
        return false;
      }
    }
    NotificationUI.instance.notificationWarning(
        'Ocurrió un error inesperado, intente de nuevo más tarde');
    return false;
  }

  static Future<bool> updatePassword(String pass, WidgetRef ref) async {
    final prefs = PreferenciasUsuario();

    final Map<String, dynamic> authData = {
      "password": pass,
      "user_id": prefs.usuarioID
    };

    String decodedResp = await BaseHttpService.basePost(
        url: UPDATE_PASSWORD, authorization: false, body: authData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);

      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess('${resp['message']}');
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning('${resp['description']['message']}');
        return false;
      }
    }
    NotificationUI.instance.notificationWarning(
        'Ocurrió un error inesperado, intente de nuevo más tarde');
    return false;
  }
}
