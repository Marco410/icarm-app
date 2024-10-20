import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
    bool authorization = false,
    Uint8List? fileBytes,
    String? flUsuario,
    bool isRadio = false}) async {
  http.Response response = http.Response("", 500);
  try {
    if (await InternetConnection().hasInternetAccess) {
      var url = Uri.https(base_url, path, params);

      headers ??= {};

      headers["Content-type"] = (isRadio) ? 'audio/mpeg' : "application/json";
      headers["Accept"] = "*/*";

      if (authorization) {
        String? token = (await storage.read(key: "tokenAuth"));
        headers["Authorization"] = 'Bearer $token';
      }

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
              if (elementPath != "") {
                request.files.add(await http.MultipartFile.fromPath(
                    keyFile![index], elementPath));
              }
            });
          }

          bodyMultipart!.forEach((key, value) {
            request.fields[key] = value;
          });

          var resp = await request.send();
          response = await http.Response.fromStream(resp);
          data = response.body;

          break;

        case "MULTIPARTPHOTO":
          List<int> fotoBytes = fileBytes!.toList();
          var request = http.MultipartRequest('POST', url)
            ..fields['userID'] = flUsuario!
            ..files.add(http.MultipartFile.fromBytes('foto_perfil', fotoBytes,
                filename: '$flUsuario.jpg'));

          var resp = await request.send();
          response = await http.Response.fromStream(resp);
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
      print("base_url");
      print(base_url);
      print(path);
      NotificationUI.instance.notificationNoInternet();
      return null;
    }
  } catch (e) {
    return null;
  }
}
