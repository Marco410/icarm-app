import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario with ChangeNotifier {
  //se hace una unica instancia de las preferencias del usuario
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }
  PreferenciasUsuario._internal();
  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String get fl_usuario {
    return _prefs.getString("fl_usuario")!;
  }

  set fl_usuario(String value) {
    _prefs.setString("fl_usuario", value);
  }

  String get ds_login {
    return _prefs.getString("ds_login")!;
  }

  set ds_login(String value) {
    _prefs.setString("ds_login", value);
  }

  String get ds_nombres {
    return _prefs.getString("ds_nombres")!;
  }

  set ds_nombres(String value) {
    _prefs.setString("ds_nombres", value);
  }

  String get ds_apaterno {
    return _prefs.getString("ds_apaterno")!;
  }

  set ds_apaterno(String value) {
    _prefs.setString("ds_apaterno", value);
  }

  String get ds_email {
    return _prefs.getString("ds_email")!;
  }

  set ds_email(String value) {
    _prefs.setString("ds_email", value);
  }

  String get ds_token_notificaciones {
    return _prefs.getString("ds_token_notificaciones")!;
  }

  set ds_token_notificaciones(String value) {
    _prefs.setString("ds_token_notificaciones", value);
  }
}
