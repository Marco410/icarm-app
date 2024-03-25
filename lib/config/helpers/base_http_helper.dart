import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../services/notification_ui_service.dart';

const storage = FlutterSecureStorage();

Future<String?> httpBase(
    {required String base_url,
    required String type,
    required String path,
    Object? body,
    Map<String, String>? headers,
    Map<String, String>? params,
    Map<String, String>? bodyMultipart,
    bool log = false,
    bool successMessage = false,
    bool showNoti = true,
    List<String>? keyFile,
    List<String>? pathFile,
    bool authorization = false}) async {
  http.Response response = http.Response("", 500);
  try {
    if (await InternetConnectionChecker().hasConnection) {
      var url = Uri.https(base_url, path, params);

      headers ??= {};
      headers["Content-type"] = "application/json";
      headers["Accept"] = "*/*";

      /*     if (authorization) {
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

        case "MULTIPART":
          final request = http.MultipartRequest('POST', url);
          if (pathFile != null && pathFile.isNotEmpty) {
            pathFile.asMap().forEach((index, elementPath) async {
              request.files.add(await http.MultipartFile.fromPath(
                  keyFile![index], elementPath));
            });
          }

          bodyMultipart!.forEach((key, value) {
            request.fields[key] = value;
          });

          var resp = await request.send();
          response = await http.Response.fromStream(resp);
          data = response.body;

          break;
      }
      print("data");
      print(data);

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
  } catch (e) {
    /*  NotificationUI.instance.notificationError(
        "Ocurrió un error en el servidor. Intenta más tarde"); */
    return null;
  }
}
