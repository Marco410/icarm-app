// To parse this JSON data, do
//
//     final eventoModel = eventoModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/IglesiaModel.dart';

EventoModel eventoModelFromJson(String str) =>
    EventoModel.fromJson(json.decode(str));

String eventoModelToJson(EventoModel data) => json.encode(data.toJson());

class EventoModel {
  String status;
  DataEvento data;

  EventoModel({
    required this.status,
    required this.data,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) => EventoModel(
        status: json["status"],
        data: DataEvento.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class DataEvento {
  List<Evento> eventos;

  DataEvento({
    required this.eventos,
  });

  factory DataEvento.fromJson(Map<String, dynamic> json) => DataEvento(
        eventos:
            List<Evento>.from(json["eventos"].map((x) => Evento.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eventos": List<dynamic>.from(eventos.map((x) => x.toJson())),
      };
}

class Evento {
  int id;
  String nombre;
  int iglesiaId;
  DateTime fechaInicio;
  DateTime fechaFin;
  String descripcion;
  dynamic direccion;
  String? imgVertical;
  String? imgHorizontal;
  int isFavorite;
  int canRegister;
  int interestedCount;
  int isPublic;
  DateTime createdAt;
  DateTime updatedAt;
  Iglesia iglesia;

  Evento({
    required this.id,
    required this.nombre,
    required this.iglesiaId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.descripcion,
    required this.direccion,
    required this.imgVertical,
    required this.imgHorizontal,
    required this.isFavorite,
    required this.canRegister,
    required this.isPublic,
    required this.interestedCount,
    required this.createdAt,
    required this.updatedAt,
    required this.iglesia,
  });

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json["id"],
        nombre: json["nombre"],
        iglesiaId: json["iglesia_id"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"] ?? json["fecha_inicio"]),
        descripcion: json["descripcion"] ?? "",
        direccion: json["direccion"] ?? "",
        imgVertical: json["img_vertical"],
        imgHorizontal: json["img_horizontal"],
        isFavorite: json["is_favorite"],
        canRegister: json["can_register"],
        isPublic: json["is_public"],
        interestedCount: json["interested_count"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        iglesia: Iglesia.fromJson(json["iglesia"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "iglesia_id": iglesiaId,
        "fecha_inicio": fechaInicio.toIso8601String(),
        "fecha_fin": fechaFin.toIso8601String(),
        "descripcion": descripcion,
        "direccion": direccion,
        "img_vertical": imgVertical,
        "img_horizontal": imgHorizontal,
        "is_favorite": isFavorite,
        "can_register": canRegister,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "iglesia": iglesia.toJson(),
      };
}
