// To parse this JSON data, do
//
//     final roleModel = roleModelFromJson(jsonString);

import 'dart:convert';

import 'UsuarioModel.dart';

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  String status;
  List<Role> roles;

  RoleModel({
    required this.status,
    required this.roles,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        status: json["status"],
        roles: List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}
