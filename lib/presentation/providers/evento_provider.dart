import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/models/EventoModel.dart';
import 'package:icarm/presentation/models/InvitadoModel.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../../config/setting/api.dart';
import 'auth_service.dart';

final imgHorizontalProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final imgVerticalProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final getEventosProvider = FutureProvider.autoDispose
    .family<List<Evento>, String>((ref, isAdmin) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_EVENTOS, authorization: true, params: {"isAdmin": isAdmin});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      EventoModel listEventos = eventoModelFromJson(decodedResp);
      for (final evento in listEventos.data.eventos) {
        if (evento.isFavorite == 1) {
          ref.read(eventoFavoriteProvider.notifier).update((state) => evento);
          break;
        } else {
          ref.read(eventoFavoriteProvider.notifier).update((state) => null);
        }
      }

      ref
          .read(listEventosProvider.notifier)
          .update((state) => listEventos.data.eventos);

      List<Option> eventoOption = [];

      for (var iglesia in listEventos.data.eventos) {
        eventoOption.add(Option(id: iglesia.id, name: iglesia.nombre));
      }

      ref
          .read(eventosOptionsListProvider.notifier)
          .update((state) => eventoOption);

      return listEventos.data.eventos;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final listEventosProvider = StateProvider.autoDispose<List<Evento>>((ref) {
  return [];
});

final eventosOptionsListProvider = StateProvider<List<Option>>((ref) => []);

final eventoFavoriteProvider = StateProvider.autoDispose<Evento?>((ref) {
  return null;
});

final eventoSelectedToPaseLista = StateProvider<Option>((ref) {
  return Option(id: 0, name: 'Seleccione:');
});

final getEventoProvider =
    FutureProvider.autoDispose.family<Evento?, String>((ref, eventoID) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_EVENTO, authorization: true, params: {"eventoID": eventoID});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      Evento evento = Evento.fromJson(resp["data"]['evento'][0]);

      if (prefs.usuarioID != "") {
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
    .family<List<Invitado>, String>((ref, eventoID) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_INVITADOS,
      authorization: true,
      params: {"user_id": prefs.usuarioID, 'evento_id': eventoID});

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
