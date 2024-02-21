import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/models/EventoModel.dart';
import 'package:icarm/presentation/models/InvitadoModel.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';

final prefs = PreferenciasUsuario();

final imgHorizontalProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final imgVerticalProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final getEventosProvider =
    FutureProvider.autoDispose<List<Evento>>((ref) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_EVENTOS, authorization: true, params: {});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      EventoModel listEventos = eventoModelFromJson(decodedResp);
      for (final evento in listEventos.data.eventos) {
        if (evento.isFavorite == 1) {
          ref.read(eventoFavoriteProvider.notifier).update((state) => evento);
          break;
        }
      }
      return listEventos.data.eventos;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final eventoFavoriteProvider = StateProvider.autoDispose<Evento?>((ref) {
  return null;
});

final getEventoProvider =
    FutureProvider.autoDispose.family<Evento?, String>((ref, eventoID) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_EVENTO, authorization: true, params: {"eventoID": eventoID});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      Evento evento = Evento.fromJson(resp["data"]['evento'][0]);

      String decodedResp = await BaseHttpService.baseGet(
          url: IS_USER_INTERESTED,
          authorization: true,
          params: {"eventoID": eventoID, 'userID': prefs.usuarioID});

      if (decodedResp != "") {
        final Map<String, dynamic> resp = json.decode(decodedResp);

        if (resp['status'] == 'Success') {
          ref
              .read(isUSerInterestedProvider.notifier)
              .update((state) => resp["data"]['interested']);
        }
      }

      return evento;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return null;
    }
  }
  return null;
});

final isUSerInterestedProvider = StateProvider.autoDispose<bool>((ref) {
  return false;
});

final getInvitadosProvider = FutureProvider.autoDispose
    .family<List<Invitado>, String>((ref, userID) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_INVITADOS, authorization: true, params: {"user_id": userID});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      InvitadoModel listInvitados = invitadoModelFromJson(decodedResp);

      return listInvitados.data.invitados;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final getEncontradoProvider = FutureProvider.autoDispose
    .family<Invitado?, String>((ref, encontradoID) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ENCONTRADO,
      authorization: true,
      params: {"encontrado_id": encontradoID});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      Invitado invitado = Invitado.fromJson(resp["data"]);

      return invitado;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return null;
    }
  }
  return null;
});
