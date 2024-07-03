import 'dart:convert';
import 'package:icarm/config/setting/api.dart';
import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';

class PagosController {
  PagosController._instance();

  static Future<bool> addPago(
      {required String usuarioID,
      required String eventoID,
      required String cantidad,
      required String concepto}) async {
    final Map<String, String> pagoData = {
      "user_id": usuarioID,
      "evento_id": eventoID,
      "cantidad": cantidad,
      "concepto": concepto,
    };

    String decodedResp = await BaseHttpService.basePost(
        url: ADD_PAGO, authorization: true, body: pagoData);

    if (decodedResp != "") {
      final Map<String, dynamic> resp = json.decode(decodedResp);
      if (resp["status"] == 'Success') {
        NotificationUI.instance
            .notificationSuccess('Pago creado exitosamente.');
        return true;
      } else {
        NotificationUI.instance
            .notificationWarning(' ${resp["description"]["message"]}');

        return false;
      }
    }

    return true;
  }
}
