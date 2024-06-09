import 'dart:convert';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

class BetelController {
  BetelController._instance();

  static Future<bool> create(
      {String? user,
      String? userName,
      String? user2,
      String? user2Name,
      String? userAnf,
      String? userAnfName,
      String? userAnf2,
      String? userAnf2Name,
      required String img,
      required String url_map,
      required String direccion,
      String? telefono,
      required bool editing,
      String? betelID}) async {
    final bodyData = {
      "betel_id": betelID ?? "",
      "user_id": user ?? "",
      "user_name": userName ?? "",
      "user2_id": user2 ?? "",
      "user2_name": user2Name ?? "",
      "user_anf_id": userAnf ?? "",
      "user_anf_name": userAnfName ?? "",
      "user_anf2_id": userAnf2 ?? "",
      "user_anf2_name": userAnf2Name ?? "",
      "map_url": url_map,
      "direccion": direccion,
      "telefono": telefono ?? "",
    };

    List<String> paths = [img];
    List<String> keysFiles = ["img"];

    String decodedResp = await BaseHttpService.baseFile(
        url: (editing) ? EDIT_BETEL : CREATE_BETEL,
        authorization: true,
        bodyMultipart: bodyData,
        pathFile: (editing) ? null : paths,
        keyFile: keysFiles);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance.notificationWarning(resp['message']);
      }
    } else {
      NotificationUI.instance
          .notificationWarning('Ocurrió un error al guardar el betel');
    }

    return false;
  }

  static Future<bool> createInterest({
    required String eventoID,
    required String usuarioID,
  }) async {
    final bodyData = {
      "eventoID": eventoID,
      "userID": usuarioID,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: MAKE_INTERESTED,
        authorization: true,
        body: bodyData,
        showNoti: true);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning('${resp["description"]["message"]}');
      }
    } else {
      NotificationUI.instance
          .notificationWarning('Ocurrió un error al guardar el evento');
    }

    return false;
  }

  static Future<bool> createNewRegister({
    String? usuarioID,
    required String usuarioInvitedID,
    required String eventoID,
    required String nombre,
    required String aPaterno,
    required String aMaterno,
    required String email,
    required String edad,
    required String genero,
    required String estadoCivil,
    required String telefono,
    required String refNombre,
    required String refTelefono,
  }) async {
    final bodyData = {
      "user_invited_id": usuarioInvitedID,
      "user_id": usuarioID ?? "",
      "evento_id": eventoID,
      "nombre": nombre,
      "a_paterno": aMaterno,
      "a_materno": aMaterno,
      "email": email,
      "edad": edad,
      "genero": genero,
      "estado_civil": estadoCivil,
      "telefono": telefono,
      "ref_nombre": refNombre,
      "ref_telefono": refTelefono,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: ENCONTRADO_REGISTER,
        authorization: true,
        body: bodyData,
        showNoti: true);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning(resp['description']['message']);
      }
    } else {
      NotificationUI.instance
          .notificationWarning('Ocurrió un error al guardar el evento');
    }

    return false;
  }
}
