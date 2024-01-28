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

  String get usuarioID {
    return _prefs.getString("usuarioID") ?? '';
  }

  set usuarioID(String value) {
    _prefs.setString("usuarioID", value);
  }

  String get nombre {
    return _prefs.getString("nombre") ?? '';
  }

  set nombre(String value) {
    _prefs.setString("nombre", value);
  }

  String get aPaterno {
    return _prefs.getString("aPaterno") ?? '';
  }

  set aPaterno(String value) {
    _prefs.setString("aPaterno", value);
  }

  String get aMaterno {
    return _prefs.getString("aMaterno") ?? '';
  }

  set aMaterno(String value) {
    _prefs.setString("aMaterno", value);
  }

  String get email {
    return _prefs.getString("email")!;
  }

  set email(String value) {
    _prefs.setString("email", value);
  }

  String get fechaNacimiento {
    return _prefs.getString("fechaNacimiento")!;
  }

  set fechaNacimiento(String value) {
    _prefs.setString("fechaNacimiento", value);
  }

  String get telefono {
    return _prefs.getString("telefono")!;
  }

  set telefono(String value) {
    _prefs.setString("telefono", value);
  }

  String get sexo {
    return _prefs.getString("sexo")!;
  }

  set sexo(String value) {
    _prefs.setString("sexo", value);
  }

  String get pais {
    return _prefs.getString("pais")!;
  }

  set pais(String value) {
    _prefs.setString("pais", value);
  }

  String get pass_update {
    return _prefs.getString("pass_update") ?? "";
  }

  set pass_update(String value) {
    _prefs.setString("pass_update", value);
  }

  List<String> get usuarioRol {
    return _prefs.getStringList("usuarioRol") ?? [];
  }

  set usuarioRol(List<String> value) {
    _prefs.setStringList("usuarioRol", value);
  }

  String get ds_token_notificaciones {
    return _prefs.getString("ds_token_notificaciones") ?? '';
  }

  set ds_token_notificaciones(String value) {
    _prefs.setString("ds_token_notificaciones", value);
  }
}
