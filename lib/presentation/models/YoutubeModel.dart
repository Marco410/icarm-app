// To parse this JSON data, do
//
//     final youtubeModel = youtubeModelFromJson(jsonString);

import 'dart:convert';

YoutubeModel youtubeModelFromJson(String str) =>
    YoutubeModel.fromJson(json.decode(str));

String youtubeModelToJson(YoutubeModel data) => json.encode(data.toJson());

class YoutubeModel {
  String kind;
  String etag;
  String regionCode;
  PageInfo pageInfo;
  List<Item> items;

  YoutubeModel({
    required this.kind,
    required this.etag,
    required this.regionCode,
    required this.pageInfo,
    required this.items,
  });

  factory YoutubeModel.fromJson(Map<String, dynamic> json) => YoutubeModel(
        kind: json["kind"],
        etag: json["etag"],
        regionCode: json["regionCode"],
        pageInfo: PageInfo.fromJson(json["pageInfo"]),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "regionCode": regionCode,
        "pageInfo": pageInfo.toJson(),
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String kind;
  String etag;
  Id id;

  Item({
    required this.kind,
    required this.etag,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        kind: json["kind"],
        etag: json["etag"],
        id: Id.fromJson(json["id"]),
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "etag": etag,
        "id": id.toJson(),
      };
}

class Id {
  String kind;
  String videoId;

  Id({
    required this.kind,
    required this.videoId,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        kind: json["kind"],
        videoId: json["videoId"],
      );

  Map<String, dynamic> toJson() => {
        "kind": kind,
        "videoId": videoId,
      };
}

class PageInfo {
  int totalResults;
  int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
        totalResults: json["totalResults"],
        resultsPerPage: json["resultsPerPage"],
      );

  Map<String, dynamic> toJson() => {
        "totalResults": totalResults,
        "resultsPerPage": resultsPerPage,
      };
}
