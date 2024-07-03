import 'dart:convert';
import 'dart:typed_data';

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
    required List<MinisteriosDatum> ministerios,
  }) async {
    List<String> rolesString = [];
    List<int> ministeriosInt = [];

    for (var rol in roles) {
      rolesString.add(rol.name);
    }

    for (var ministerio in ministerios) {
      ministeriosInt.add(ministerio.ministerio.id);
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
      "ministerios": ministeriosInt,
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

  static Future<String> updateFotoPerfil(Uint8List croppedData,
      {required Uint8List nbFoto}) async {
    final prefs = PreferenciasUsuario();

    String resp = await BaseHttpService.basePhoto(
        url: UPDATE_FOTO_PERFIL,
        authorization: true,
        flUsuario: prefs.usuarioID,
        photo: nbFoto);

    final Map<String, dynamic> decodedResp = json.decode(resp);

    if (decodedResp['status'] == 'Success') {
      NotificationUI.instance.notificationSuccess('${decodedResp['message']}');

      return decodedResp['nameFoto'];
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al actualizar tu foto de perfil');
      return "";
    }
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
