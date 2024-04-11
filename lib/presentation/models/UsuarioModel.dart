// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

import 'package:icarm/presentation/models/IglesiaModel.dart';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  String status;
  List<User> users;

  UsuarioModel({
    required this.status,
    required this.users,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        status: json["status"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class User {
  int id;
  String nombre;
  String apellidoPaterno;
  String? apellidoMaterno;
  String email;
  String? telefono;
  DateTime? fechaNacimiento;
  Sexo? sexo;
  int? edad;
  String? maestro;
  String? asignacion;
  int paisId;
  int active;
  String updateinf;
  int passUpdate;
  DateTime createdAt;
  DateTime updatedAt;
  Iglesia? iglesia;
  Pais? pais;
  List<Role> roles;
  String? fotoPerfil;
  MaestroVision? maestroVision;

  User({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.email,
    required this.telefono,
    required this.fechaNacimiento,
    required this.sexo,
    required this.edad,
    required this.maestro,
    required this.asignacion,
    required this.paisId,
    required this.active,
    required this.updateinf,
    required this.passUpdate,
    required this.createdAt,
    required this.updatedAt,
    required this.iglesia,
    required this.roles,
    required this.pais,
    required this.fotoPerfil,
    this.maestroVision,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"] ?? "",
        email: json["email"],
        telefono: json["telefono"],
        fechaNacimiento: json["fecha_nacimiento"] == null
            ? null
            : DateTime.parse(json["fecha_nacimiento"]),
        sexo: json["sexo"] == null ? null : Sexo.fromJson(json["sexo"]),
        edad: json["edad"],
        maestro: json["maestro"],
        asignacion: json["asignacion"] ?? "",
        paisId: json["pais_id"],
        active: json["active"],
        updateinf: json["updateinf"],
        passUpdate: json["pass_update"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        iglesia:
            json["iglesia"] == null ? null : Iglesia.fromJson(json["iglesia"]),
        pais: json["pais"] == null ? null : Pais.fromJson(json["pais"]),
        roles: (json["roles"] == null)
            ? []
            : List<Role>.from(json["roles"].map((x) => Role.fromJson(x))),
        fotoPerfil: json["foto_perfil"] ?? null,
        maestroVision: json["maestro_vision"] == null
            ? null
            : MaestroVision.fromJson(json["maestro_vision"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "email": email,
        "telefono": telefono,
        "fecha_nacimiento":
            "${fechaNacimiento!.year.toString().padLeft(4, '0')}-${fechaNacimiento!.month.toString().padLeft(2, '0')}-${fechaNacimiento!.day.toString().padLeft(2, '0')}",
        "edad": edad,
        "maestro": maestro,
        "asignacion": asignacion,
        "pais_id": paisId,
        "active": active,
        "updateinf": updateinf,
        "pass_update": passUpdate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "iglesia": iglesia?.toJson(),
        "pais": pais?.toJson(),
        "sexo": sexo?.toJson(),
        "roles": List<dynamic>.from(roles.map((x) => x.toJson())),
      };
}

class Role {
  int id;
  String name;
  String guardName;
  DateTime? createdAt;
  DateTime? updatedAt;

  Role({
    required this.id,
    required this.name,
    required this.guardName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        guardName: json["guard_name"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "guard_name": guardName,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Pais {
  int id;
  String name;

  Pais({
    required this.id,
    required this.name,
  });

  factory Pais.fromJson(Map<String, dynamic> json) => Pais(
        id: json["id"],
        name: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": name,
      };
}

class Sexo {
  int id;
  String name;

  Sexo({
    required this.id,
    required this.name,
  });

  factory Sexo.fromJson(Map<String, dynamic> json) => Sexo(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Pivot {
  int modelId;
  int roleId;
  ModelType modelType;

  Pivot({
    required this.modelId,
    required this.roleId,
    required this.modelType,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        modelId: json["model_id"],
        roleId: json["role_id"],
        modelType: modelTypeValues.map[json["model_type"]]!,
      );

  Map<String, dynamic> toJson() => {
        "model_id": modelId,
        "role_id": roleId,
        "model_type": modelTypeValues.reverse[modelType],
      };
}

enum ModelType { APP_MODELS_USER }

final modelTypeValues =
    EnumValues({"App\\Models\\User": ModelType.APP_MODELS_USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class MaestroVision {
  int id;
  int userId;
  int maestroId;
  User maestroUser;

  MaestroVision({
    required this.id,
    required this.userId,
    required this.maestroId,
    required this.maestroUser,
  });

  factory MaestroVision.fromJson(Map<String, dynamic> json) => MaestroVision(
        id: json["id"],
        userId: json["user_id"],
        maestroId: json["maestro_id"],
        maestroUser: User.fromJson(json["maestro_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "maestro_id": maestroId,
        "maestro_user": maestroUser.toJson(),
      };
}
