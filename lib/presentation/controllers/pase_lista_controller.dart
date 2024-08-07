import 'dart:convert';

import 'package:icarm/config/setting/api.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../models/UsuarioModel.dart';

class PaseListaController {
  PaseListaController._instance();

  static Future<bool> addPaseLista(
      {required String usuarioID, required String eventoID}) async {
    final Map<String, String> getUser = {
      "user_id": usuarioID,
      "evento_id": eventoID
    };

    String decodedResp = await BaseHttpService.basePost(
        url: ADD_USER_PASE_URL, authorization: true, body: getUser);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess('Pase de lista exitoso.');
        /* paseListaData.context.pop(); */
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning('${resp["description"]["message"]}');

        return false;
      }
    }

    return true;
  }

  static Future<bool> updateUserPaseLista({
    required String userID,
    required String nombre,
    required String apellido_paterno,
    required String apellido_materno,
    required String fecha_nacimiento,
    required String telefono,
    required String maestro_id,
    required String asignacion,
    required int epastores,
    required List<MinisteriosDatum> ministerios,
  }) async {
    List<int> ministeriosInt = [];

    for (var ministerio in ministerios) {
      ministeriosInt.add(ministerio.ministerio.id);
    }
    final updateUser = {
      "userID": userID,
      "nombre": nombre,
      "apellido_paterno": apellido_paterno,
      "apellido_materno": apellido_materno,
      "fecha_nacimiento": fecha_nacimiento,
      "telefono": telefono,
      "maestro_id": maestro_id,
      "asignacion": asignacion,
      "ministerios": ministeriosInt,
      "epastores": epastores,
    };

    String decodedResp = await BaseHttpService.basePut(
        url: UPDATE_USER_PASE_URL, authorization: true, body: updateUser);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess(resp['message']);
        return true;
      } else {
        NotificationUI.instance.notificationWarning(
            'No pudimos completar la operación, inténtelo más tarde.');
        return false;
      }
    }
    return true;
  }
}
