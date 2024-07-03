import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/models/BetelModel.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

final betelesProvider = FutureProvider<List<Betele>>((ref) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_BETELES, authorization: true, params: {});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      BetelModel listKids = betelModelFromJson(decodedResp);
      return listKids.data.beteles;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});
