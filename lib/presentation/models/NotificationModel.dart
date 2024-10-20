// To parse this JSON data, do
//
//     final notificacionesModel = notificacionesModelFromJson(jsonString);

import 'dart:convert';

NotificacionesModel notificacionesModelFromJson(String str) =>
    NotificacionesModel.fromJson(json.decode(str));

String notificacionesModelToJson(NotificacionesModel data) =>
    json.encode(data.toJson());

class NotificacionesModel {
  String status;
  dynamic message;
  Data data;

  NotificacionesModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificacionesModel.fromJson(Map<String, dynamic> json) =>
      NotificacionesModel(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  List<Notificacione> notificaciones;

  Data({
    required this.notificaciones,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        notificaciones: List<Notificacione>.from(
            json["notificaciones"].map((x) => Notificacione.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notificaciones":
            List<dynamic>.from(notificaciones.map((x) => x.toJson())),
      };
}

class Notificacione {
  int id;
  int userID;
  int? senderID;
  String title;
  String body;
  String data;
  String type;
  int seen;
  DateTime createdAt;
  DateTime updatedAt;

  Notificacione({
    required this.id,
    required this.userID,
    required this.senderID,
    required this.title,
    required this.body,
    required this.data,
    required this.type,
    required this.seen,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Notificacione.fromJson(Map<String, dynamic> json) => Notificacione(
        id: json["id"],
        userID: json["user_id"],
        senderID: json["sender_id"],
        title: json["title"],
        body: json["body"],
        data: json["data"],
        type: json["type"],
        seen: json["seen"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userID,
        "sender_id": senderID,
        "title": title,
        "body": body,
        "data": data,
        "type": type,
        "seen": seen,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
