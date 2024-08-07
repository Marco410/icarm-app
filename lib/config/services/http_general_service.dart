import 'dart:typed_data';

import 'package:icarm/config/helpers/base_http_helper.dart';
import 'package:icarm/config/setting/api.dart';

class BaseHttpService {
  static Future<String> baseGetYoutube(
      {required String url,
      bool authorization = false,
      Map<String, String>? params}) async {
    String? response = await httpBase(
        base_url: YOUTUBE_BASE,
        type: "GET",
        path: url,
        authorization: authorization,
        showNoti: false,
        params: params);
    return (response != null) ? response : "";
  }

  static Future<String> baseGet(
      {required String url,
      bool authorization = false,
      Map<String, String>? params}) async {
    String? response = await httpBase(
        base_url: BASE_URL,
        type: "GET",
        path: url,
        authorization: authorization,
        params: params);
    return (response != null) ? response : "";
  }

  static Future<String> basePost(
      {required String url,
      bool authorization = false,
      bool showNoti = true,
      required Map<String, dynamic> body}) async {
    String? response = await httpBase(
        base_url: BASE_URL,
        type: "POST",
        path: url,
        authorization: authorization,
        showNoti: showNoti,
        body: body);
    return (response != null) ? response : "";
  }

  static Future<String> basePut(
      {required String url,
      bool authorization = false,
      required Map<String, dynamic> body}) async {
    String? response = await httpBase(
        base_url: BASE_URL,
        type: "PUT",
        path: url,
        authorization: authorization,
        body: body);
    return (response != null) ? response : "";
  }

  static Future<String> baseFile(
      {required String url,
      bool authorization = false,
      required List<String> keyFile,
      List<String>? pathFile,
      required Map<String, String> bodyMultipart}) async {
    String? response = await httpBase(
      base_url: BASE_URL,
      type: "MULTIPART",
      path: url,
      authorization: authorization,
      keyFile: keyFile,
      pathFile: pathFile,
      bodyMultipart: bodyMultipart,
    );
    return (response != null) ? response : "";
  }

  static Future<String> basePhoto(
      {required String url,
      bool authorization = false,
      Uint8List? photo,
      bool showNoti = true,
      required String flUsuario}) async {
    String? response = await httpBase(
        type: "MULTIPARTPHOTO",
        path: url,
        authorization: authorization,
        flUsuario: flUsuario,
        showNoti: showNoti,
        fileBytes: photo,
        base_url: BASE_URL);

    return (response != null) ? response : "";
  }

  static Future<String> baseGetRadio(
      {required String url,
      bool authorization = false,
      Map<String, String>? params}) async {
    String? response = await httpBase(
        base_url: "www.amoryrestauracionmorelia.com",
        type: "GET",
        path: url,
        authorization: authorization,
        params: params,
        isRadio: true);
    return (response != null) ? response : "";
  }
}
