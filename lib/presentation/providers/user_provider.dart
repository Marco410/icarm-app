import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/api.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../models/auth/authModels.dart';

final sendNotiUserProvider =
    FutureProvider.family<void, NotiUserData>((ref, notiData) async {
  final Map<String, dynamic> notiBody = {
    "user_id": notiData.userIDToSend,
    "title": notiData.title,
    "msg": notiData.msg,
  };

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePost(
      url: SEND_NOTI_USER, authorization: true, body: notiBody);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess(resp["message"]);
      notiData.context.pop();
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al registrarte. ${resp["description"]["message"]}');
    }
  }
});
