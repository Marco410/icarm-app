import 'dart:convert';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

class EventoController {
  EventoController._instance();

  static Future<bool> createEvent(
      {required String nombre,
      required String iglesiaID,
      required String fechaInicio,
      required String fechaFin,
      required String descripcion,
      String? direccion,
      required bool isFavorite,
      required bool canRegister,
      String? imgVertical,
      String? imgHorizontal,
      String? eventoID,
      required bool editing}) async {
    final bodyData = {
      "nombre": nombre,
      "iglesia_id": iglesiaID,
      "fecha_inicio": fechaInicio,
      "fecha_fin": fechaFin,
      "descripcion": descripcion,
      "direccion": (direccion != null) ? direccion : "",
      "is_favorite": (isFavorite) ? "1" : "0",
      "can_register": (canRegister) ? "1" : "0",
    };

    if (editing) {
      bodyData["evento_id"] = eventoID!;
    }

    List<String> paths = [imgVertical ?? "", imgHorizontal ?? ""];

    List<String> keysFiles = ["img_vertical", "img_horizontal"];

    String decodedResp = await BaseHttpService.baseFile(
        url: (editing) ? EDIT_EVENTO : ADD_EVENTO,
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
          .notificationWarning('Ocurrió un error al guardar el evento');
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
        NotificationUI.instance.notificationWarning(resp['message']);
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
