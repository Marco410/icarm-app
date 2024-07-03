// To parse this JSON data, do
//
//     final findUsersModel = findUsersModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/UsuarioModel.dart';

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
