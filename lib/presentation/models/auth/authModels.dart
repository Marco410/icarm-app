import 'package:flutter/material.dart';

class LoginData {
  final String email;
  final String password;
  final BuildContext context;

  LoginData({
    required this.email,
    required this.password,
    required this.context,
  });
}

class RegisterUserData {
  final String nombre;
  final String a_paterno;
  final String a_materno;
  final int? user_id;
  final String? fecha_nacimiento;
  final String? email;
  final String? password;
  final String? telefono;
  final String? sexo;
  final String? sexo_id;
  final int? pais_id;
  final BuildContext context;

  RegisterUserData({
    required this.nombre,
    required this.a_paterno,
    required this.a_materno,
    this.email,
    this.user_id,
    this.password,
    this.fecha_nacimiento,
    this.telefono,
    this.sexo,
    this.pais_id,
    this.sexo_id,
    required this.context,
  });
}

class NotiUserData {
  final String title;
  final String msg;
  final String userIDToSend;
  final BuildContext context;

  NotiUserData({
    required this.title,
    required this.msg,
    required this.userIDToSend,
    required this.context,
  });
}
