// To parse this JSON data, do
//
//     final findUsersModel = findUsersModelFromJson(jsonString);

import 'dart:convert';

FindUsersModel findUsersModelFromJson(String str) =>
    FindUsersModel.fromJson(json.decode(str));

String findUsersModelToJson(FindUsersModel data) => json.encode(data.toJson());

class FindUsersModel {
  String status;
  Data data;

  FindUsersModel({
    required this.status,
    required this.data,
  });

  factory FindUsersModel.fromJson(Map<String, dynamic> json) => FindUsersModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<User> users;

  Data({
    required this.users,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  int id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String email;
  String telefono;
  String fechaNacimiento;
  String sexo;
  int edad;
  String maestro;
  String asignacion;
  int paisId;
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
    required this.updateinf,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"] ?? '',
        email: json["email"] ?? '',
        telefono: json["telefono"] ?? '',
        fechaNacimiento: json["fecha_nacimiento"] ?? '',
        sexo: json["sexo"] ?? '',
        edad: json["edad"] ?? 0,
        maestro: json["maestro"] ?? '',
        asignacion: json["asignacion"] ?? '',
        paisId: json["pais_id"],
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
        "fecha_nacimiento": fechaNacimiento,
        "sexo": sexo,
        "edad": edad,
        "maestro": maestro,
        "asignacion": asignacion,
        "pais_id": paisId,
        "updateinf": updateinf.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
