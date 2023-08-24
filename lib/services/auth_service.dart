//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icarm/share_prefs/prefs_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'base_service.dart';

class AuthService extends ChangeNotifier {
  final prefs = new PreferenciasUsuario();
  final baseService = BaseService();

  final String _baseUrl = GlobalConfiguration().getValue('base_url');
  final String _loginUrl = GlobalConfiguration().getValue('login');

  final storage = new FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final Map<String, dynamic> authData = {
      "username": username,
      "password": password
    };

    final decodedResp = baseService.basePost(_loginUrl, authData);

    final Map<String, dynamic> resp = json.decode(await decodedResp);

    if (resp["error"]) {
      return resp;
    } else {
      await storage.write(
          key: 'tokenAuth', value: resp['data']['access_token']);
      prefs.fl_usuario = resp['data']['usuario']['fl_usuario'].toString();
      prefs.ds_login = resp['data']['usuario']['ds_login'].toString();
      prefs.ds_nombres = resp['data']['usuario']['ds_nombres'].toString();
      prefs.ds_apaterno = resp['data']['usuario']['ds_apaterno'].toString();
      prefs.ds_email = resp['data']['usuario']['ds_email'].toString();
      prefs.ds_token_notificaciones =
          resp['data']['usuario']['ds_token_notificaciones'].toString();

      return resp;
    }
  }

  Future logout() async {
    await storage.delete(key: "tokenAuth");

    prefs.ds_login = "";
    prefs.ds_nombres = "";
    prefs.ds_apaterno = "";
    prefs.ds_email = "";
    prefs.ds_token_notificaciones = "";
  }

  Future<String> isAuth() async {
    return await storage.read(key: "tokenAuth") ?? '';
  }

  Future<Map<String, dynamic>> getSymbols() async {
    return {};
  }
}
