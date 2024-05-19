// To parse this JSON data, do
//
//     final ministerioModel = ministerioModelFromJson(jsonString);

import 'dart:convert';

MinisterioModel ministerioModelFromJson(String str) =>
    MinisterioModel.fromJson(json.decode(str));

String ministerioModelToJson(MinisterioModel data) =>
    json.encode(data.toJson());

class MinisterioModel {
  String status;
  List<Ministerio> ministerios;

  MinisterioModel({
    required this.status,
    required this.ministerios,
  });

  factory MinisterioModel.fromJson(Map<String, dynamic> json) =>
      MinisterioModel(
        status: json["status"],
        ministerios: List<Ministerio>.from(
            json["ministerios"].map((x) => Ministerio.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "ministerios": List<dynamic>.from(ministerios.map((x) => x.toJson())),
      };
}

class Ministerio {
  int id;
  String name;

  Ministerio({
    required this.id,
    required this.name,
  });

  factory Ministerio.fromJson(Map<String, dynamic> json) => Ministerio(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
