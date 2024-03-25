// ignore_for_file: use_build_context_synchronously, unused_result, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icarm/config/setting/api.dart';
import '../../config/routes/app_router.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/share_prefs/prefs_usuario.dart';
import '../models/models.dart';

const storage = FlutterSecureStorage();
final prefs = PreferenciasUsuario();

/* -------------------------------------------------------
 Function login user
*/
final loginProvider =
    FutureProvider.family<void, LoginData>((ref, loginData) async {
  /* try { */
  final Map<String, dynamic> authData = {
    "email": loginData.email,
    "password": loginData.password
  };

  String decodedResp = await BaseHttpService.basePost(
      url: LOGIN_URL, authorization: false, body: authData);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);

    if (resp["status"] != 'Success') {
      NotificationUI.instance.notificationWarning('${resp['message']}');
      return;
    }

    AuthService.storeData(resp);

    NavigationRoutes.goHome(loginData.context);
  }
  /*  } catch (e) {
    NotificationUI.instance.notificationError("Ha ocurrido un error");
  } */
});

/* -------------------------------------------------------
 Function register user
*/

final registerProvider = FutureProvider.family<void, RegisterUserData>(
    (ref, registerUserData) async {
  final Map<String, dynamic> registerUser = {
    "nombre": registerUserData.nombre,
    "apellido_paterno": registerUserData.a_paterno,
    "apellido_materno": registerUserData.a_materno,
    "fecha_nacimiento": registerUserData.fecha_nacimiento,
    "email": registerUserData.email,
    "password": registerUserData.password,
    "telefono": registerUserData.telefono,
    "sexo":
        (registerUserData.sexo != "Seleccione") ? registerUserData.sexo : '',
    "pais_id": registerUserData.pais_id,
    "sexo_id": registerUserData.sexo_id,
  };

  String decodedResp = "";

  if (registerUserData.user_id != null) {
    registerUser['userId'] = registerUserData.user_id;
    decodedResp = await BaseHttpService.basePost(
        url: UPDATE_USER_URL, authorization: false, body: registerUser);
  } else {
    decodedResp = await BaseHttpService.basePost(
        url: REGISTER_USER_URL, authorization: false, body: registerUser);
  }

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      AuthService.storeData(resp);
      NavigationRoutes.goHome(registerUserData.context);
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al registrarte. ${resp["description"]["message"]}');
    }
  }
});

final findUserRegisterProvider = FutureProvider.autoDispose
    .family<void, RegisterUserData>((ref, registerUserData) async {
  final Map<String, dynamic> findRegisterUser = {
    "nombre": registerUserData.nombre,
    "a_paterno": registerUserData.a_paterno,
    "a_materno": registerUserData.a_materno,
  };

  String decodedResp = await BaseHttpService.basePost(
      url: FIND_REGISTER_USER_URL,
      authorization: false,
      body: findRegisterUser);

  FindUsersModel aseguradoraData = findUsersModelFromJson(decodedResp);
  ref
      .read(findUsersRegisterList.notifier)
      .update((state) => aseguradoraData.data.users);
});

final findUsersRegisterList = StateProvider.autoDispose<List<User>>((ref) {
  return [];
});

final logoutProvider =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  AuthService.deleteData();

  NavigationRoutes.goLogin(context);
});

final deleteAccountProvider =
    FutureProvider.family<void, BuildContext>((ref, context) async {
  final Map<String, dynamic> userId = {"userId": prefs.usuarioID};

  String decodedResp = await BaseHttpService.basePost(
      url: DELETE_ACCOUNT, authorization: false, body: userId);

  final Map<String, dynamic> resp = json.decode(decodedResp);

  if (resp["status"] == 'Success') {
    NotificationUI.instance.notificationSuccess('${resp['message']}');
    AuthService.deleteData();
    NavigationRoutes.goLogin(context);
  } else {
    NotificationUI.instance.notificationWarning(
        'Ocurrió un error al registrarte. ${resp["description"]["message"]}');
  }
});

class AuthService {
  static Future<void> storeData(Map<String, dynamic> resp) async {
    await storage.write(key: 'tokenAuth', value: resp['data']['token']);

    String usuarioID = resp['data']['user']['id'].toString();
    String nombre = resp['data']['user']['nombre'].toString();
    String aPaterno = resp['data']['user']['apellido_paterno'].toString();
    String? aMaterno = resp['data']['user']['apellido_materno'] ?? '';

    prefs.usuarioID = usuarioID;
    prefs.nombre = nombre;
    prefs.aPaterno = aPaterno;
    prefs.aMaterno = aMaterno ?? '';
    prefs.fechaNacimiento = resp['data']['user']['fecha_nacimiento'].toString();
    prefs.email = resp['data']['user']['email'].toString();
    prefs.telefono = resp['data']['user']['telefono'].toString();
    prefs.sexo = resp['data']['user']['sexo'].toString();
    prefs.pais = resp['data']['user']['pais_id'].toString();
    prefs.pass_update = resp['data']['user']['pass_update'].toString();
    prefs.foto_perfil = resp['data']['user']['foto_perfil'].toString();

    List<String> roles = [];
    for (final rol in resp['data']['user']['roles']) {
      roles.add(rol['id'].toString());
    }
    prefs.usuarioRol = roles;
  }

  static Future<void> deleteData() async {
    await storage.delete(key: "tokenAuth");

    prefs.usuarioID = "";
    prefs.nombre = "";
    prefs.aPaterno = "";
    prefs.aMaterno = "";
    prefs.fechaNacimiento = "";
    prefs.email = "";
    prefs.telefono = "";
    prefs.sexo = "";
    prefs.pais = "";
    prefs.usuarioRol = [];
    prefs.foto_perfil = "";
  }
}
