// ignore_for_file: use_build_context_synchronously, unused_result, unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/models/IglesiaModel.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/share_prefs/prefs_usuario.dart';

const storage = FlutterSecureStorage();
final prefs = PreferenciasUsuario();

final getIglesiasProvider = FutureProvider<void>((ref) async {
  final Map<String, String> getIglesiaData = {};

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_IGLESIAS, authorization: true, params: getIglesiaData);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      IglesiaModel listIglesia = iglesiaModelFromJson(decodedResp);

      List<Option> iglesiaOptionList = [];

      for (var iglesia in listIglesia.data.iglesias) {
        iglesiaOptionList.add(Option(id: iglesia.id, name: iglesia.nombre));
      }

      ref
          .read(iglesiaListProvider.notifier)
          .update((state) => iglesiaOptionList);
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
    }
  }
});

final iglesiaListProvider = StateProvider<List<Option>>((ref) => []);
