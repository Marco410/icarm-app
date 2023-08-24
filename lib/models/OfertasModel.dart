// To parse this JSON data, do
//
//     final ofertasModel = ofertasModelFromJson(jsonString);

import 'dart:convert';

OfertasModel ofertasModelFromJson(String str) =>
    OfertasModel.fromJson(json.decode(str));

String ofertasModelToJson(OfertasModel data) => json.encode(data.toJson());

class OfertasModel {
  int code;
  List<Ofertas> ofertas;
  bool error;
  dynamic typeError;
  String message;

  OfertasModel({
    required this.code,
    required this.ofertas,
    required this.error,
    this.typeError,
    required this.message,
  });

  factory OfertasModel.fromJson(Map<String, dynamic> json) => OfertasModel(
        code: json["code"],
        ofertas:
            List<Ofertas>.from(json["data"].map((x) => Ofertas.fromJson(x))),
        error: json["error"],
        typeError: json["typeError"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "ofertas": List<dynamic>.from(ofertas.map((x) => x.toJson())),
        "error": error,
        "typeError": typeError,
        "message": message,
      };
}

class Ofertas {
  CProductoOFertas cProducto;
  CUsuarioAdminOFertas cUsuarioAdmin;
  int flPromocionProducto;
  String nbPromocion;
  String dsPromocion;
  int flProducto;
  DateTime feIniVigencia;
  DateTime feFinVigencia;
  DateTime feIniOperacion;
  DateTime feFinOperacion;
  String fgEstatus;
  DateTime feAlta;
  DateTime feUltacc;
  int flUsuAlta;

  Ofertas({
    required this.cProducto,
    required this.cUsuarioAdmin,
    required this.flPromocionProducto,
    required this.nbPromocion,
    required this.dsPromocion,
    required this.flProducto,
    required this.feIniVigencia,
    required this.feFinVigencia,
    required this.feIniOperacion,
    required this.feFinOperacion,
    required this.fgEstatus,
    required this.feAlta,
    required this.feUltacc,
    required this.flUsuAlta,
  });

  factory Ofertas.fromJson(Map<String, dynamic> json) => Ofertas(
        cProducto: CProductoOFertas.fromJson(json["c_producto"]),
        cUsuarioAdmin: CUsuarioAdminOFertas.fromJson(json["c_usuario_admin"]),
        flPromocionProducto: json["fl_promocion_producto"],
        nbPromocion: json["nb_promocion"],
        dsPromocion: json["ds_promocion"],
        flProducto: json["fl_producto"],
        feIniVigencia: DateTime.parse(json["fe_ini_vigencia"]),
        feFinVigencia: DateTime.parse(json["fe_fin_vigencia"]),
        feIniOperacion: DateTime.parse(json["fe_ini_operacion"]),
        feFinOperacion: DateTime.parse(json["fe_fin_operacion"]),
        fgEstatus: json["fg_estatus"],
        feAlta: DateTime.parse(json["fe_alta"]),
        feUltacc: DateTime.parse(json["fe_ultacc"]),
        flUsuAlta: json["fl_usu_alta"],
      );

  Map<String, dynamic> toJson() => {
        "c_producto": cProducto.toJson(),
        "c_usuario_admin": cUsuarioAdmin.toJson(),
        "fl_promocion_producto": flPromocionProducto,
        "nb_promocion": nbPromocion,
        "ds_promocion": dsPromocion,
        "fl_producto": flProducto,
        "fe_ini_vigencia": feIniVigencia.toIso8601String(),
        "fe_fin_vigencia": feFinVigencia.toIso8601String(),
        "fe_ini_operacion": feIniOperacion.toIso8601String(),
        "fe_fin_operacion": feFinOperacion.toIso8601String(),
        "fg_estatus": fgEstatus,
        "fe_alta": feAlta.toIso8601String(),
        "fe_ultacc": feUltacc.toIso8601String(),
        "fl_usu_alta": flUsuAlta,
      };
}

class CProductoOFertas {
  CUsuarioAdminOFertas cUsuarioAdmin;
  int flProducto;
  String nbProducto;
  String dsProducto;
  String nbImagenProducto;
  DateTime feAlta;
  DateTime feUltacc;
  int flUsuAlta;
  String fgActivo;

  CProductoOFertas({
    required this.cUsuarioAdmin,
    required this.flProducto,
    required this.nbProducto,
    required this.dsProducto,
    required this.nbImagenProducto,
    required this.feAlta,
    required this.feUltacc,
    required this.flUsuAlta,
    required this.fgActivo,
  });

  factory CProductoOFertas.fromJson(Map<String, dynamic> json) =>
      CProductoOFertas(
        cUsuarioAdmin: CUsuarioAdminOFertas.fromJson(json["c_usuario_admin"]),
        flProducto: json["fl_producto"],
        nbProducto: json["nb_producto"],
        dsProducto: json["ds_producto"],
        nbImagenProducto: json["nb_imagen_producto"],
        feAlta: DateTime.parse(json["fe_alta"]),
        feUltacc: DateTime.parse(json["fe_ultacc"]),
        flUsuAlta: json["fl_usu_alta"],
        fgActivo: json["fg_activo"],
      );

  Map<String, dynamic> toJson() => {
        "c_usuario_admin": cUsuarioAdmin.toJson(),
        "fl_producto": flProducto,
        "nb_producto": nbProducto,
        "ds_producto": dsProducto,
        "nb_imagen_producto": nbImagenProducto,
        "fe_alta": feAlta.toIso8601String(),
        "fe_ultacc": feUltacc.toIso8601String(),
        "fl_usu_alta": flUsuAlta,
        "fg_activo": fgActivo,
      };
}

class CUsuarioAdminOFertas {
  int flUsuarioAdmin;
  String dsLogin;
  String dsPassword;
  String dsNombres;
  String dsApaterno;
  dynamic dsAmaterno;
  String dsEmail;
  String fgActivo;
  DateTime feAlta;
  DateTime feUltacc;
  int noAccesosWeb;

  CUsuarioAdminOFertas({
    required this.flUsuarioAdmin,
    required this.dsLogin,
    required this.dsPassword,
    required this.dsNombres,
    required this.dsApaterno,
    this.dsAmaterno,
    required this.dsEmail,
    required this.fgActivo,
    required this.feAlta,
    required this.feUltacc,
    required this.noAccesosWeb,
  });

  factory CUsuarioAdminOFertas.fromJson(Map<String, dynamic> json) =>
      CUsuarioAdminOFertas(
        flUsuarioAdmin: json["fl_usuario_admin"],
        dsLogin: json["ds_login"],
        dsPassword: json["ds_password"],
        dsNombres: json["ds_nombres"],
        dsApaterno: json["ds_apaterno"],
        dsAmaterno: json["ds_amaterno"],
        dsEmail: json["ds_email"],
        fgActivo: json["fg_activo"],
        feAlta: DateTime.parse(json["fe_alta"]),
        feUltacc: DateTime.parse(json["fe_ultacc"]),
        noAccesosWeb: json["no_accesos_web"],
      );

  Map<String, dynamic> toJson() => {
        "fl_usuario_admin": flUsuarioAdmin,
        "ds_login": dsLogin,
        "ds_password": dsPassword,
        "ds_nombres": dsNombres,
        "ds_apaterno": dsApaterno,
        "ds_amaterno": dsAmaterno,
        "ds_email": dsEmail,
        "fg_activo": fgActivo,
        "fe_alta": feAlta.toIso8601String(),
        "fe_ultacc": feUltacc.toIso8601String(),
        "no_accesos_web": noAccesosWeb,
      };
}
