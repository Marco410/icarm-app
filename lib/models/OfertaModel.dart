// To parse this JSON data, do
//
//     final ofertaModel = ofertaModelFromJson(jsonString);

import 'dart:convert';

OfertaModel ofertaModelFromJson(String str) =>
    OfertaModel.fromJson(json.decode(str));

String ofertaModelToJson(OfertaModel data) => json.encode(data.toJson());

class OfertaModel {
  int code;
  OfertaData ofertaData;
  bool error;
  dynamic typeError;
  String message;

  OfertaModel({
    required this.code,
    required this.ofertaData,
    required this.error,
    this.typeError,
    required this.message,
  });

  factory OfertaModel.fromJson(Map<String, dynamic> json) => OfertaModel(
        code: json["code"],
        ofertaData: OfertaData.fromJson(json["data"]),
        error: json["error"],
        typeError: json["typeError"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": ofertaData.toJson(),
        "error": error,
        "typeError": typeError,
        "message": message,
      };
}

class OfertaData {
  Oferta oferta;
  OfertaDataProducto producto;
  String dsCondiciones;

  OfertaData({
    required this.oferta,
    required this.producto,
    required this.dsCondiciones,
  });

  factory OfertaData.fromJson(Map<String, dynamic> json) => OfertaData(
        oferta: Oferta.fromJson(json["oferta"]),
        producto: OfertaDataProducto.fromJson(json["producto"]),
        dsCondiciones: json["ds_condiciones"],
      );

  Map<String, dynamic> toJson() => {
        "oferta": oferta.toJson(),
        "producto": producto.toJson(),
        "ds_condiciones": dsCondiciones,
      };
}

class Oferta {
  CProductoClass cProducto;
  CUsuarioAdmin cUsuarioAdmin;
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

  Oferta({
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

  factory Oferta.fromJson(Map<String, dynamic> json) => Oferta(
        cProducto: CProductoClass.fromJson(json["c_producto"]),
        cUsuarioAdmin: CUsuarioAdmin.fromJson(json["c_usuario_admin"]),
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

class CProductoClass {
  CUsuarioAdmin cUsuarioAdmin;
  int flProducto;
  String nbProducto;
  String dsProducto;
  String nbImagenProducto;
  DateTime feAlta;
  DateTime feUltacc;
  int flUsuAlta;
  String fgActivo;

  CProductoClass({
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

  factory CProductoClass.fromJson(Map<String, dynamic> json) => CProductoClass(
        cUsuarioAdmin: CUsuarioAdmin.fromJson(json["c_usuario_admin"]),
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

class CUsuarioAdmin {
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

  CUsuarioAdmin({
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

  factory CUsuarioAdmin.fromJson(Map<String, dynamic> json) => CUsuarioAdmin(
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

class OfertaDataProducto {
  CProductoClass producto;
  List<Recurso> recursos;

  OfertaDataProducto({
    required this.producto,
    required this.recursos,
  });

  factory OfertaDataProducto.fromJson(Map<String, dynamic> json) =>
      OfertaDataProducto(
        producto: CProductoClass.fromJson(json["producto"]),
        recursos: List<Recurso>.from(
            json["recursos"].map((x) => Recurso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "producto": producto.toJson(),
        "recursos": List<dynamic>.from(recursos.map((x) => x.toJson())),
      };
}

class Recurso {
  CProductoClass cProducto;
  int flRecurso;
  int flProducto;
  int flTipoRecurso;
  String nbRecurso;
  String dsRecurso;
  String dsNombreArchivo;
  String fgActivo;

  Recurso({
    required this.cProducto,
    required this.flRecurso,
    required this.flProducto,
    required this.flTipoRecurso,
    required this.nbRecurso,
    required this.dsRecurso,
    required this.dsNombreArchivo,
    required this.fgActivo,
  });

  factory Recurso.fromJson(Map<String, dynamic> json) => Recurso(
        cProducto: CProductoClass.fromJson(json["c_producto"]),
        flRecurso: json["fl_recurso"],
        flProducto: json["fl_producto"],
        flTipoRecurso: json["fl_tipo_recurso"],
        nbRecurso: json["nb_recurso"],
        dsRecurso: json["ds_recurso"],
        dsNombreArchivo: json["ds_nombre_archivo"],
        fgActivo: json["fg_activo"],
      );

  Map<String, dynamic> toJson() => {
        "c_producto": cProducto.toJson(),
        "fl_recurso": flRecurso,
        "fl_producto": flProducto,
        "fl_tipo_recurso": flTipoRecurso,
        "nb_recurso": nbRecurso,
        "ds_recurso": dsRecurso,
        "ds_nombre_archivo": dsNombreArchivo,
        "fg_activo": fgActivo,
      };
}
