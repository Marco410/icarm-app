// To parse this JSON data, do
//
//     final kidsInClassModel = kidsInClassModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/kids/TeacherModel.dart';

KidsInClassModel kidsInClassModelFromJson(String str) =>
    KidsInClassModel.fromJson(json.decode(str));

String kidsInClassModelToJson(KidsInClassModel data) =>
    json.encode(data.toJson());

class KidsInClassModel {
  String status;
  List<Classroom> data;

  KidsInClassModel({
    required this.status,
    required this.data,
  });

  factory KidsInClassModel.fromJson(Map<String, dynamic> json) =>
      KidsInClassModel(
        status: json["status"],
        data: List<Classroom>.from(
            json["data"].map((x) => Classroom.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KidWithUser {
  int id;
  int userId;
  String nombre;
  String aPaterno;
  String aMaterno;
  DateTime fechaNacimiento;
  String sexo;
  String? enfermedad;
  int active;
  DateTime createdAt;
  User user;

  KidWithUser({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.aPaterno,
    required this.aMaterno,
    required this.fechaNacimiento,
    required this.sexo,
    required this.enfermedad,
    required this.active,
    required this.createdAt,
    required this.user,
  });

  factory KidWithUser.fromJson(Map<String, dynamic> json) => KidWithUser(
        id: json["id"],
        userId: json["user_id"],
        nombre: json["nombre"],
        aPaterno: json["a_paterno"],
        aMaterno: json["a_materno"] ?? '',
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        sexo: json["sexo"],
        enfermedad: json["enfermedad"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nombre": nombre,
        "a_paterno": aPaterno,
        "a_materno": aMaterno,
        "fecha_nacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "sexo": sexo,
        "enfermedad": enfermedad,
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  int id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String email;
  String telefono;
  DateTime fechaNacimiento;
  String sexo;
  int? edad;
  String? maestro;
  String? asignacion;
  int paisId;
  int active;
  DateTime updateinf;
  DateTime createdAt;
  DateTime updatedAt;

  User({
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
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
      };
}
