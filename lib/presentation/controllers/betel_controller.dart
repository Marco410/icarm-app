import 'dart:convert';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

class BetelController {
  BetelController._instance();

  static Future<bool> create(
      {String? user,
      String? userName,
      String? user2,
      String? user2Name,
      String? userAnf,
      String? userAnfName,
      String? userAnf2,
      String? userAnf2Name,
      required String img,
      required String url_map,
      required String direccion,
      String? telefono,
      required bool editing,
      String? betelID}) async {
    final bodyData = {
      "betel_id": betelID ?? "",
      "user_id": user ?? "",
      "user_name": userName ?? "",
      "user2_id": user2 ?? "",
      "user2_name": user2Name ?? "",
      "user_anf_id": userAnf ?? "",
      "user_anf_name": userAnfName ?? "",
      "user_anf2_id": userAnf2 ?? "",
      "user_anf2_name": userAnf2Name ?? "",
      "map_url": url_map,
      "direccion": direccion,
      "telefono": telefono ?? "",
    };

    List<String> paths = [img];
    List<String> keysFiles = ["img"];

    String decodedResp = await BaseHttpService.baseFile(
        url: (editing) ? EDIT_BETEL : CREATE_BETEL,
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
          .notificationWarning('Ocurrió un error al guardar el betel');
    }

    return false;
  }

  static Future<bool> delete(String betelID) async {
    final bodyData = {
      "betel_id": betelID,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: DELETE_BETEL, authorization: true, body: bodyData);

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
