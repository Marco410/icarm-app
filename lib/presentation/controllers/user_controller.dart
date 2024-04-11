import 'dart:convert';

import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/models/UsuarioModel.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

class UserController {
  UserController._instance();

  static Future<bool> updateUser({
    required String userID,
    required String nombre,
    required String apellido_paterno,
    required String apellido_materno,
    required String fecha_nacimiento,
    required String email,
    required String telefono,
    required String sexo_id,
    required String pais_id,
    required String iglesia_id,
    required List<Role> roles,
  }) async {
    List<String> rolesString = [];

    for (var rol in roles) {
      rolesString.add(rol.name);
    }

    final bodyData = {
      "userID": userID,
      "nombre": nombre,
      "apellido_paterno": apellido_paterno,
      "apellido_materno": apellido_materno,
      "email": email,
      "fecha_nacimiento": fecha_nacimiento,
      "telefono": telefono,
      "sexo_id": sexo_id,
      "pais_id": pais_id,
      "iglesia_id": iglesia_id,
      "roles": rolesString,
    };

    String decodedResp = await BaseHttpService.basePut(
        url: UPDATE_USER, authorization: true, body: bodyData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance.notificationWarning(resp['message']);
      }
    } else {
      NotificationUI.instance
          .notificationWarning('Ocurrió un error al actualizar');
    }

    return false;
  }

  static Future<bool> updateFotoPerfil({required String foto_perfil}) async {
    final prefs = PreferenciasUsuario();

    final bodyData = {"userID": prefs.usuarioID, "foto_perfil": foto_perfil};

    List<String> paths = [foto_perfil];

    List<String> keysFiles = ["foto_perfil"];

    String decodedResp = await BaseHttpService.baseFile(
        url: UPDATE_FOTO_PERFIL,
        authorization: true,
        bodyMultipart: bodyData,
        pathFile: paths,
        keyFile: keysFiles);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        prefs.foto_perfil = resp["nameFoto"];
        NotificationUI.instance.notificationSuccess(resp['message']);

        return true;
      } else {
        NotificationUI.instance.notificationWarning(resp['message']);
      }
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al actualizar tu foto de perfil');
    }

    return false;
  }

  static Future<bool> deleteFotoPerfil() async {
    final prefs = PreferenciasUsuario();

    final bodyData = {"userID": prefs.usuarioID};

    String decodedResp = await BaseHttpService.basePost(
        url: DELETE_FOTO_PERFIL, authorization: true, body: bodyData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance.notificationSuccess(resp['message']);
        return true;
      } else {
        NotificationUI.instance.notificationWarning(resp['message']);
      }
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al actualizar tu foto de perfil');
    }

    return false;
  }
}
