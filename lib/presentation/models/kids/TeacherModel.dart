// To parse this JSON data, do
//
//     final teachersModel = teachersModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/kids/kidsInClassModel.dart';

TeachersModel teachersModelFromJson(String str) =>
    TeachersModel.fromJson(json.decode(str));

String teachersModelToJson(TeachersModel data) => json.encode(data.toJson());

class TeachersModel {
  String status;
  List<Teacher> teachers;

  TeachersModel({
    required this.status,
    required this.teachers,
  });

  factory TeachersModel.fromJson(Map<String, dynamic> json) => TeachersModel(
        status: json["status"],
        teachers: List<Teacher>.from(
            json["teachers"].map((x) => Teacher.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
      };
}

class Classroom {
  int id;
  int userId;
  int kidId;
  int isIn;
  DateTime createdAt;
  KidWithUser kid;

  Classroom({
    required this.id,
    required this.userId,
    required this.kidId,
    required this.isIn,
    required this.createdAt,
    required this.kid,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) => Classroom(
        id: json["id"],
        userId: json["user_id"],
        kidId: json["kid_id"],
        isIn: json["is_in"],
        createdAt: DateTime.parse(json["created_at"]),
        kid: KidWithUser.fromJson(json["kid"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "kid_id": kidId,
        "is_in": isIn,
        "created_at": createdAt.toIso8601String(),
        "kid": kid.toJson(),
      };
}

class Teacher {
  int id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String email;
  String telefono;
  DateTime fechaNacimiento;
  String? sexo;
  int? edad;
  String maestro;
  String? asignacion;
  int paisId;
  int active;
  DateTime updateinf;
  DateTime createdAt;
  DateTime updatedAt;
  List<Classroom>? classroom;

  Teacher({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.sexo,
    required this.edad,
    required this.maestro,
    required this.asignacion,
    required this.paisId,
    required this.active,
    required this.updateinf,
    required this.createdAt,
    required this.updatedAt,
    this.classroom,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        email: json["email"],
        telefono: json["telefono"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        sexo: json["sexo"],
        edad: json["edad"],
        maestro: json["maestro"],
        asignacion: json["asignacion"],
        paisId: json["pais_id"],
        active: json["active"],
        updateinf: DateTime.parse(json["updateinf"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        classroom: json["classroom"] == null
            ? []
            : List<Classroom>.from(
                json["classroom"]!.map((x) => Classroom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "email": email,
        "telefono": telefono,
        "fecha_nacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "sexo": sexo,
        "edad": edad,
        "maestro": maestro,
        "asignacion": asignacion,
        "pais_id": paisId,
        "active": active,
        "updateinf": updateinf.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "classroom": classroom == null
            ? []
            : List<dynamic>.from(classroom!.map((x) => x.toJson())),
      };
}
