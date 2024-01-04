import 'package:flutter/material.dart';

class KidRegisterData {
  final int? kid_id;
  final String? nombre;
  final String? a_paterno;
  final String? a_materno;
  final String? fecha_nacimiento;
  final String? sexo;
  final String? enfermedad;
  final BuildContext context;

  KidRegisterData({
    this.kid_id,
    this.nombre,
    this.a_paterno,
    this.a_materno,
    this.fecha_nacimiento,
    this.sexo,
    this.enfermedad,
    required this.context,
  });
}

class KidRegisterTeacherData {
  final String kid_id;
  final BuildContext context;

  KidRegisterTeacherData({
    required this.kid_id,
    required this.context,
  });
}

class ExitClassData {
  final String class_id;
  final BuildContext context;

  ExitClassData({
    required this.class_id,
    required this.context,
  });
}
