import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/models/DefaultsModel.dart';
import 'package:icarm/presentation/models/RoleModel.dart';
import 'package:icarm/presentation/models/UserModel.dart';
import 'package:icarm/presentation/models/UsuarioModel.dart';
import 'package:image_picker/image_picker.dart';

import '../../config/services/http_general_service.dart';
import '../../config/services/notification_ui_service.dart';
import '../models/auth/authModels.dart';

final fileSelectedProvider = StateProvider.autoDispose<PlatformFile?>((ref) {
  return null;
});

final imageSelectedProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final photoProfileSelectedProvider = StateProvider.autoDispose<XFile?>((ref) {
  return null;
});

final sendNotiUserProvider =
    FutureProvider.family<void, NotiUserData>((ref, notiData) async {
  final Map<String, dynamic> notiBody = {
    "user_id": notiData.userIDToSend,
    "title": notiData.title,
    "msg": notiData.msg,
  };

  String decodedResp = "";

  decodedResp = await BaseHttpService.basePost(
      url: SEND_NOTI_USER, authorization: true, body: notiBody);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      NotificationUI.instance.notificationSuccess(resp["message"]);
    } else {
      NotificationUI.instance.notificationWarning(
          'Ocurrió un error al registrarte. ${resp["description"]["message"]}');
    }
  }
});

final getUsersAllProvider = FutureProvider<List<User>>((ref) async {
  final filters = ref.watch(filterUsersProvider);
  final body = {"nombre": filters.nombre, "role": filters.role};

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ALL_USERS, authorization: true, params: body);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      UsuarioModel listUsers = usuarioModelFromJson(decodedResp);
      List<Option> users = [];
      for (User user in listUsers.users) {
        users.add(Option(
            id: user.id,
            name:
                "${user.nombre} ${user.apellidoPaterno} ${user.apellidoMaterno}",
            description: "Roles: " +
                user.roles.map((e) => e.name.toString()).join(" | ")));
      }

      ref.read(getUserListProvider.notifier).update((state) => users);

      return listUsers.users;
    } else {
      return [];
    }
  }
  return [];
});

final filterUsersProvider = StateProvider<FilterUser>((ref) {
  FilterUser filters = FilterUser(nombre: "", role: "");
  return filters;
});

final getUserListProvider = StateProvider<List<Option>>((ref) => []);

final getMaestrosListProvider = FutureProvider<List<User>>((ref) async {
  final body = {"role": "Maestro"};

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ALL_USERS, authorization: true, params: body);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      UsuarioModel listMaestros = usuarioModelFromJson(decodedResp);
      List<Option> users = [];
      for (User maestro in listMaestros.users) {
        users.add(Option(
          id: maestro.id,
          name:
              "${maestro.nombre} ${maestro.apellidoPaterno} ${maestro.apellidoMaterno}",
        ));
      }

      ref.read(maestrosListOptionProvider.notifier).update((state) => users);

      return listMaestros.users;
    } else {
      return [];
    }
  }
  return [];
});

final maestrosListOptionProvider = StateProvider<List<Option>>((ref) => []);

final getUserProvider =
    FutureProvider.family.autoDispose<User?, String>((ref, userID) async {
  final body = {"userID": userID};

  String decodedResp = await BaseHttpService.baseGet(
      url: GET_USER, authorization: true, params: body);

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      UserModel user = userModelFromJson(decodedResp);

      return user.user;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return null;
    }
  }
  return null;
});

final getRolesProvider = FutureProvider.autoDispose<List<Role>>((ref) async {
  String decodedResp = await BaseHttpService.baseGet(
      url: GET_ALL_ROLES, authorization: true, params: {});

  if (decodedResp != "") {
    final Map<String, dynamic> resp = json.decode(decodedResp);
    if (resp["status"] == 'Success') {
      RoleModel listRoles = roleModelFromJson(decodedResp);

      ref.read(rolesListProvider.notifier).update((state) => listRoles.roles);

      List<Option> rolesOptions = [];

      for (var role in listRoles.roles) {
        rolesOptions.add(Option(id: role.id, name: role.name));
      }

      ref
          .read(rolesOptionsListProvider.notifier)
          .update((state) => rolesOptions);

      return listRoles.roles;
    } else {
      NotificationUI.instance.notificationWarning(
          'No pudimos completar la operación, inténtelo más tarde.');
      return [];
    }
  }
  return [];
});

final rolesListProvider = StateProvider<List<Role>>((ref) => []);
final rolesOptionsListProvider = StateProvider<List<Option>>((ref) => []);
final editingUserProvider = StateProvider<bool>((ref) => false);
