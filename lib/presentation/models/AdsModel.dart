// To parse this JSON data, do
//
//     final adsModel = adsModelFromJson(jsonString);

import 'dart:convert';

AdsModel adsModelFromJson(String str) => AdsModel.fromJson(json.decode(str));

String adsModelToJson(AdsModel data) => json.encode(data.toJson());

class AdsModel {
  String status;
  Data data;

  AdsModel({
    required this.status,
    required this.data,
  });

  factory AdsModel.fromJson(Map<String, dynamic> json) => AdsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Ad> ads;

  Data({
    required this.ads,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
      };
}

class Ad {
  int id;
  String title;
  String subtitle;
  String img;
  String module;
  int active;
  DateTime createdAt;

  Ad({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.img,
    required this.module,
    required this.active,
    required this.createdAt,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        img: json["img"],
        module: json["module"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "img": img,
        "module": module,
        "active": active,
        "created_at": createdAt.toIso8601String(),
      };
}
