// To parse this JSON data, do
//
//     final tutorsModel = tutorsModelFromJson(jsonString);

import 'dart:convert';

import 'UsuarioModel.dart';

TutorsModel tutorsModelFromJson(String str) =>
    TutorsModel.fromJson(json.decode(str));

String tutorsModelToJson(TutorsModel data) => json.encode(data.toJson());

class TutorsModel {
  String status;
  List<Datum> data;

  TutorsModel({
    required this.status,
    required this.data,
  });

  factory TutorsModel.fromJson(Map<String, dynamic> json) => TutorsModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  int tutorId;
  int kidId;
  DateTime createdAt;
  User user;

  Datum({
    required this.id,
    required this.tutorId,
    required this.kidId,
    required this.createdAt,
    required this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
