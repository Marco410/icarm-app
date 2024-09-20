import 'dart:convert';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

class AdController {
  AdController._instance();

  static Future<bool> create(
      {required String img,
      required String title,
      required String subtitle,
      required bool editing,
      String? adID}) async {
    final bodyData = {
      "ad_id": adID ?? "",
      "title": title,
      "subtitle": subtitle,
      "module": 'home'
    };

    List<String> paths = [img];
    List<String> keysFiles = ["img"];

    String decodedResp = await BaseHttpService.baseFile(
        url: (editing) ? EDIT_AD : CREATE_AD,
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
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> delete(String adID) async {
    final bodyData = {
      "ad_id": adID,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: DELETE_AD, authorization: true, body: bodyData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        return true;
      } else {
        NotificationUI.instance.notificationWarning(resp['message']);
      }
    } else {
      NotificationUI.instance
          .notificationWarning('Ocurrió un error al eliminar el betel');
    }
    return false;
  }
}
