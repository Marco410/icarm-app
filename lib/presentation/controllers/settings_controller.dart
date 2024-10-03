import 'dart:convert';
import 'package:icarm/config/setting/api.dart';
import '../../config/services/http_general_service.dart';

class SettingsController {
  SettingsController._instance();

  static Future<Map<String, dynamic>?> getVersion() async {
    String decodedResp =
        await BaseHttpService.baseGet(url: GET_VERSION, authorization: true);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        print(resp["data"]["version"]);
        return resp["data"]["version"];
      } else {
        return null;
      }
    }

    return null;
  }
}
