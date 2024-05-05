// To parse this JSON data, do
//
//     final kidsInClassModel = kidsInClassModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/UsuarioModel.dart';
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
  List<Tutor> tutors;

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
    required this.tutors,
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
        tutors: List<Tutor>.from(json["tutors"].map((x) => Tutor.fromJson(x))),
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
        "tutors": List<dynamic>.from(tutors.map((x) => x.toJson())),
      };
}

class Tutor {
  int id;
  int tutorId;
  int kidId;
  DateTime createdAt;
  User user;

  Tutor({
    required this.id,
    required this.tutorId,
    required this.kidId,
    required this.createdAt,
    required this.user,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => Tutor(
        id: json["id"],
        tutorId: json["tutor_id"],
        kidId: json["kid_id"],
        createdAt: DateTime.parse(json["created_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tutor_id": tutorId,
        "kid_id": kidId,
        "created_at": createdAt.toIso8601String(),
        "user": user.toJson(),
      };
}
