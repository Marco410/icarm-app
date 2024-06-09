// To parse this JSON data, do
//
//     final betelModel = betelModelFromJson(jsonString);

import 'dart:convert';

import 'UsuarioModel.dart';

BetelModel betelModelFromJson(String str) =>
    BetelModel.fromJson(json.decode(str));

String betelModelToJson(BetelModel data) => json.encode(data.toJson());

class BetelModel {
  String status;
  Data data;

  BetelModel({
    required this.status,
    required this.data,
  });

  factory BetelModel.fromJson(Map<String, dynamic> json) => BetelModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Betele> beteles;

  Data({
    required this.beteles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        beteles:
            List<Betele>.from(json["beteles"].map((x) => Betele.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "beteles": List<dynamic>.from(beteles.map((x) => x.toJson())),
      };
}

class Betele {
  int id;
  int userId;
  int user2Id;
  int userAnfId;
  int userAnf2Id;
  String? userName;
  String? user2Name;
  String? userAnfName;
  String? userAnf2Name;
  String img;
  String mapUrl;
  String direccion;
  String? telefono;
  User? user;
  User? user2;
  User? userAnf;
  User? userAnf2;

  Betele({
    required this.id,
    required this.userId,
    required this.user2Id,
    required this.userAnfId,
    required this.userAnf2Id,
    required this.userName,
    required this.user2Name,
    required this.userAnfName,
    required this.userAnf2Name,
    required this.img,
    required this.mapUrl,
    required this.direccion,
    required this.telefono,
    required this.user,
    required this.user2,
    required this.userAnf,
    required this.userAnf2,
  });

  factory Betele.fromJson(Map<String, dynamic> json) => Betele(
        id: json["id"],
        userId: json["user_id"],
        user2Id: json["user2_id"],
        userAnfId: json["user_anf_id"],
        userAnf2Id: json["user_anf2_id"],
        userName: json["user_name"],
        user2Name: json["user2_name"],
        userAnfName: json["user_anf_name"],
        userAnf2Name: json["user_anf2_name"],
        img: json["img"],
        mapUrl: json["map_url"],
        direccion: json["direccion"],
        telefono: json["telefono"] == null ? null : json["telefono"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        user2: json["user2"] == null ? null : User.fromJson(json["user2"]),
        userAnf:
            json["user_anf"] == null ? null : User.fromJson(json["user_anf"]),
        userAnf2:
            json["user_anf2"] == null ? null : User.fromJson(json["user_anf2"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "user2_id": user2Id,
        "user_anf_id": userAnfId,
        "user_anf2_id": userAnf2Id,
        "user_name": userName,
        "user2_name": user2Name,
        "user_anf_name": userAnfName,
        "user_anf2_name": userAnf2Name,
        "img": img,
        "map_url": mapUrl,
        "direccion": direccion,
        "telefono": telefono,
        "user": user?.toJson(),
        "user2": user2?.toJson(),
        "user_anf": userAnf?.toJson(),
        "user_anf2": userAnf2?.toJson(),
      };
}
