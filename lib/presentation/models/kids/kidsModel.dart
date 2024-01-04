// To parse this JSON data, do
//
//     final kidsModel = kidsModelFromJson(jsonString);

import 'dart:convert';

KidsModel kidsModelFromJson(String str) => KidsModel.fromJson(json.decode(str));

String kidsModelToJson(KidsModel data) => json.encode(data.toJson());

class KidsModel {
  String status;
  Data data;

  KidsModel({
    required this.status,
    required this.data,
  });

  factory KidsModel.fromJson(Map<String, dynamic> json) => KidsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Kid> kids;

  Data({
    required this.kids,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        kids: List<Kid>.from(json["kids"].map((x) => Kid.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kids": List<dynamic>.from(kids.map((x) => x.toJson())),
      };
}

class Kid {
  int id;
  int userId;
  String nombre;
  String aPaterno;
  String aMaterno;
  DateTime fechaNacimiento;
  DateTime createAt;
  String sexo;
  String enfermedad;
  int active;

  Kid({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.aPaterno,
    required this.aMaterno,
    required this.fechaNacimiento,
    required this.createAt,
    required this.sexo,
    required this.enfermedad,
    required this.active,
  });

  factory Kid.fromJson(Map<String, dynamic> json) => Kid(
        id: json["id"],
        userId: json["user_id"],
        nombre: json["nombre"],
        aPaterno: json["a_paterno"],
        aMaterno: json["a_materno"] ?? '',
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        createAt: DateTime.parse(json["created_at"]),
        sexo: json["sexo"],
        enfermedad: json["enfermedad"] ?? '',
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "nombre": nombre,
        "a_paterno": aPaterno,
        "a_materno": aMaterno,
        "fecha_nacimiento":
            "${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}",
        "sexo": sexo,
        "enfermedad": enfermedad,
        "active": active,
      };
}
