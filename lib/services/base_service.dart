import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';

class BaseService extends ChangeNotifier {
  final String _baseUrl = GlobalConfiguration().getValue('base_url');
  final storage = new FlutterSecureStorage();

  Future<String> baseGet(_urlBaseCall) async {
    final url = Uri.https(_baseUrl, _urlBaseCall);
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*",
    };
    final resp = await http.get(url, headers: userHeader);
    return resp.body;
  }

  Future<String> baseGetParams(_urlBaseCall, params) async {
    String? _token = (await storage.read(key: "tokenAuth"));

    final url = Uri.https(_baseUrl, _urlBaseCall, params);
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*",
      'Authorization': 'Bearer $_token',
    };
    print("url");
    print(url);
    final resp = await http.get(url, headers: userHeader);
    return resp.body;
  }

  Future<String> baseGetAuth(_urlBaseCall) async {
    String? _token = (await storage.read(key: "tokenAuth"));

    final url = Uri.https(_baseUrl, _urlBaseCall);
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*",
      'Authorization': 'Bearer $_token',
    };
    final resp = await http.get(url, headers: userHeader);
    print(resp.body);
    return resp.body;
  }

  Future<String> basePost(_urlBaseCall, _data) async {
    final url = Uri.https(_baseUrl, _urlBaseCall);
    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*"
    };
    final resp =
        await http.post(url, body: json.encode(_data), headers: userHeader);

    return resp.body;
  }

  Future<String> basePostAuth(_urlBaseCall, _data) async {
    final url = Uri.https(_baseUrl, _urlBaseCall);
    String? _token = (await storage.read(key: "tokenAuth"));

    print(url);

    Map<String, String> userHeader = {
      "Content-type": "application/json",
      "Accept": "*/*",
      'Authorization': 'Bearer $_token',
    };
    final resp =
        await http.post(url, body: json.encode(_data), headers: userHeader);

    return resp.body;
  }
}
