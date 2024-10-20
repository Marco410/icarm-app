import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/services/http_general_service.dart';
import 'package:icarm/config/setting/api.dart';

import '../providers/auth_service.dart';

class NotificationController {
  NotificationController._instance();

  static Future<bool> notifyUser(
      String flUsuarioToNotify, String title, String msg, WidgetRef ref) async {
    await BaseHttpService.basePost(
        url: NOTIFICATION_SEND_USER,
        authorization: true,
        body: {"user_id": flUsuarioToNotify, "title": title, "body": msg});

    return false;
  }

  static Future<void> seen(String flNotification) async {
    final bodyPost = {
      "noti_id": flNotification,
    };
    await BaseHttpService.basePost(
        url: NOTIFICATION_SEEN, authorization: true, body: bodyPost);
  }

  static Future<void> delete(String flNotification) async {
    final bodyPost = {
      "noti_id": flNotification,
    };
    await BaseHttpService.basePost(
        url: NOTIFICATION_DELETE, authorization: true, body: bodyPost);
  }

  static Future<void> deleteAll() async {
    final bodyPost = {
      "user_id": prefs.usuarioID,
    };
    await BaseHttpService.basePost(
        url: NOTIFICATION_DELETE_ALL, authorization: true, body: bodyPost);
  }

  static Future<void> seeAll() async {
    final bodyPost = {
      "user_id": prefs.usuarioID,
    };
    await BaseHttpService.basePost(
        url: NOTIFICATION_SEEN_ALL, authorization: true, body: bodyPost);
  }
}
