// To parse this JSON data, do
//
//     final invitadoModel = invitadoModelFromJson(jsonString);

import 'dart:convert';

InvitadoModel invitadoModelFromJson(String str) =>
    InvitadoModel.fromJson(json.decode(str));

String invitadoModelToJson(InvitadoModel data) => json.encode(data.toJson());

class InvitadoModel {
  String status;
  Data data;

  InvitadoModel({
    required this.status,
    required this.data,
  });

  factory InvitadoModel.fromJson(Map<String, dynamic> json) => InvitadoModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Invitado> invitados;

  Data({
    required this.invitados,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        invitados: List<Invitado>.from(
            json["invitados"].map((x) => Invitado.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "invitados": List<dynamic>.from(invitados.map((x) => x.toJson())),
      };
}

class Invitado {
  int id;
  int? userId;
  int userInvitedId;
  int eventoId;
  String nombre;
  String aPaterno;
  String aMaterno;
  String email;
  String edad;
  String genero;
  String estadoCivil;
  String telefono;
  String refNombre;
  String refTelefono;
  DateTime createdAt;
  DateTime updatedAt;

  Invitado({
    required this.id,
    required this.userId,
    required this.userInvitedId,
    required this.eventoId,
    required this.nombre,
    required this.aPaterno,
    required this.aMaterno,
    required this.email,
    required this.edad,
    required this.genero,
    required this.estadoCivil,
    required this.telefono,
    required this.refNombre,
    required this.refTelefono,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invitado.fromJson(Map<String, dynamic> json) => Invitado(
        id: json["id"],
        userId: json["user_id"],
        userInvitedId: json["user_invited_id"],
        eventoId: json["evento_id"],
        nombre: json["nombre"],
        aPaterno: json["a_paterno"],
        aMaterno: json["a_materno"],
        email: json["email"],
        edad: json["edad"],
        genero: json["genero"],
        estadoCivil: json["estado_civil"],
        telefono: json["telefono"],
        refNombre: json["ref_nombre"],
        refTelefono: json["ref_telefono"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user_invited_id": userInvitedId,
        "evento_id": eventoId,
        "nombre": nombre,
        "a_paterno": aPaterno,
        "a_materno": aMaterno,
        "email": email,
        "edad": edad,
        "genero": genero,
        "estado_civil": estadoCivil,
        "telefono": telefono,
        "ref_nombre": refNombre,
        "ref_telefono": refTelefono,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
