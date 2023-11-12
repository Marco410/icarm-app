import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:icarm/config/setting/api.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../services/notification_ui_service.dart';

Future<String?> httpBase(
    {required String base_url,
    required String type,
    required String path,
    Object? body,
    Map<String, String>? headers,
    Map<String, String>? params,
    bool log = false,
    bool successMessage = false,
    bool showNoti = true,
    bool authorization = false}) async {
  http.Response response = http.Response("", 500);
  /* try { */
  if (await InternetConnectionChecker().hasConnection) {
    var url = Uri.https(base_url, path, params);

    headers ??= {};
    headers["Content-type"] = "application/json";
    headers["Accept"] = "*/*";

    /*  if (authorization) {
      String? token = (await storage.read(key: "tokenAuth"));
      headers["Authorization"] = 'Bearer $token';
    } */

    if (type != "MULTIPART") {
      body = json.encode(body);
    }

    late String data;
    switch (type) {
      case "POST":
        response = await http.post(url, body: body, headers: headers);
        data = response.body;
        break;
      case "PUT":
        response = await http.put(url, body: body, headers: headers);
        data = response.body;
        break;
      case "GET":
        response = await http.get(url, headers: headers);
        data = response.body;
        break;
      case "DELETE":
        response = await http.delete(url, body: body, headers: headers);
        data = response.body;
        break;
    }

    if (response.statusCode == 200) {
      return data;
    } else {
      final Map<String, dynamic> resp = json.decode(data);

      if (resp["status"] == 'Success') {
        if (showNoti) {
          NotificationUI.instance.notificationAlert('${resp['message']}', "");
        }
        return data;
      }
      if (showNoti) {
        NotificationUI.instance.notificationError("Ocurrió un error");
      }
      return data;
    }
  } else {
    NotificationUI.instance.notificationNoInternet();
    return null;
  }
  /* } catch (e) {
    NotificationUI.instance.notificationError(
        "Ocurrió un error en el servidor. Intenta más tarde");
    return null;
  } */
}
