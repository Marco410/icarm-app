// To parse this JSON data, do
//
//     final iglesiaModel = iglesiaModelFromJson(jsonString);

import 'dart:convert';

IglesiaModel iglesiaModelFromJson(String str) =>
    IglesiaModel.fromJson(json.decode(str));

String iglesiaModelToJson(IglesiaModel data) => json.encode(data.toJson());

class IglesiaModel {
  String status;
  Data data;

  IglesiaModel({
    required this.status,
    required this.data,
  });

  factory IglesiaModel.fromJson(Map<String, dynamic> json) => IglesiaModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  List<Iglesia> iglesias;

  Data({
    required this.iglesias,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iglesias: List<Iglesia>.from(
            json["iglesias"].map((x) => Iglesia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "iglesias": List<dynamic>.from(iglesias.map((x) => x.toJson())),
      };
}

class Iglesia {
  int id;
  int userId;
  String nombre;
  String web;
  String calle;
  String numero;
  String colonia;
  String cp;
  String ciudad;
  String estado;
  String pais;
  String lat;
  String lng;
  String telefono;
  String facebook;
  String instagram;
  String youtube;
  String pastores;
  String horarios;
  String mision;
  String historia;
  dynamic createdAt;
  dynamic updatedAt;

  Iglesia({
    required this.id,
    required this.userId,
    required this.nombre,
    required this.web,
    required this.calle,
    required this.numero,
    required this.colonia,
    required this.cp,
    required this.ciudad,
    required this.estado,
    required this.pais,
    required this.lat,
    required this.lng,
    required this.telefono,
    required this.facebook,
    required this.instagram,
    required this.youtube,
    required this.pastores,
    required this.horarios,
    required this.mision,
    required this.historia,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Iglesia.fromJson(Map<String, dynamic> json) => Iglesia(
        id: json["id"],
        userId: json["user_id"],
        nombre: json["nombre"],
        web: json["web"],
        calle: json["calle"],
        numero: json["numero"],
        colonia: json["colonia"],
        cp: json["cp"],
        ciudad: json["ciudad"],
        estado: json["estado"],
        pais: json["pais"],
        lat: json["lat"],
        lng: json["lng"],
        telefono: json["telefono"],
        facebook: json["facebook"],
        instagram: json["instagram"],
        youtube: json["youtube"],
        pastores: json["pastores"],
        horarios: json["horarios"],
        mision: json["mision"],
        historia: json["historia"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "nombre": nombre,
        "web": web,
        "calle": calle,
        "numero": numero,
        "colonia": colonia,
        "cp": cp,
        "ciudad": ciudad,
        "estado": estado,
        "pais": pais,
        "lat": lat,
        "lng": lng,
        "telefono": telefono,
        "facebook": facebook,
        "instagram": instagram,
        "youtube": youtube,
        "pastores": pastores,
        "horarios": horarios,
        "mision": mision,
        "historia": historia,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
