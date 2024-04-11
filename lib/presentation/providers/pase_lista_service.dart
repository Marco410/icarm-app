// ignore_for_file: use_build_context_synchronously, unused_result, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/models/paselista/paseListaModels.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/share_prefs/prefs_usuario.dart';
import '../models/UsuarioModel.dart';

const storage = FlutterSecureStorage();
final prefs = PreferenciasUsuario();

final userScannedProvider = StateProvider.autoDispose<User?>((ref) {
  return null;
});

final loadingUserScannedProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final editUserPaseListProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final getUserPaseListaProvider =
    FutureProvider.family.autoDispose<void, String>((ref, user_id) async {
  final Map<String, String> getUser = {
    "user_id": user_id,
  };

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_USER_PASE_URL, authorization: true, params: getUser);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      User userGet = User.fromJson(resp['data']['user']);

      String user =
          "${resp['data']['user']['nombre']} ${resp['data']['user']['apellido_paterno']} ${resp['data']['user']['apellido_materno']}";

      int iD = resp['data']['user']['id'];

      ref.read(userScannedProvider.notifier).update((state) => userGet);
      ref.read(loadingUserScannedProvider.notifier).update((state) => false);
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde. ${resp["description"]["message"]}');

      ref.read(userScannedProvider.notifier).update((state) => null);
      ref.read(loadingUserScannedProvider.notifier).update((state) => false);
    }
  }
});

final addPaseListaProvider =
    FutureProvider.family<void, PaseListaData>((ref, paseListaData) async {
  final Map<String, String> getUser = {
    "user_id": paseListaData.user_id,
  };

  String decodedResp = await BaseHttpService.basePost(
      url: ADD_USER_PASE_URL, authorization: true, body: getUser);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess('Pase de lista exitoso.');
      paseListaData.context.pop();
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde. ${resp["description"]["message"]}');

      ref.read(userScannedProvider.notifier).update((state) => null);
    }
  }
});
