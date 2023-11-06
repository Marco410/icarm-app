// ignore_for_file: unused_result

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/DB/database.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:sqflite/sqflite.dart';

var databaseFuture = DatabaseHelper.db.database;
const TABLE = "notificaciones";

final newNotiProvider = StateProvider<bool>((ref) {
  return false;
});

final newNotiSearchProvider = FutureProvider((ref) async {
  final Database database = await databaseFuture;

  final notisMap = await database.query(
    TABLE,
    orderBy: "id DESC",
  );

  bool isNew = notisMap.toList().any((element) => element['seen'] == "0");
  ref.read(newNotiProvider.notifier).update((state) => isNew);
});

final notiListProvider = StateProvider<List<Map<String, Object?>>>((ref) {
  return [];
});

final getNotiListProvider = FutureProvider((ref) async {
  final Database database = await databaseFuture;

  final notisMap = await database.query(
    TABLE,
    orderBy: "id DESC",
  );

  ref.read(notiListProvider.notifier).update((state) => notisMap.toList());
});

final notiSelectedGetProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) {
  return [];
});

final notiSelectedProvider = FutureProvider.family((ref, notiID) async {
  final Database database = await databaseFuture;

  var getDataPaused = await database.query(TABLE, where: 'id = "$notiID"');

  await database.update(TABLE, {'seen': "1"}, where: 'id = "$notiID"');

  ref.read(notiSelectedGetProvider.notifier).update((state) => getDataPaused);
  ref.refresh(getNotiListProvider);
  ref.refresh(newNotiSearchProvider);
});

final deleteNotiProvider = FutureProvider.family((ref, notiID) async {
  final Database database = await databaseFuture;

  await database.delete(TABLE, where: 'id = "$notiID"');

  ref.refresh(getNotiListProvider);
  ref.refresh(newNotiSearchProvider);

  NotificationUI.instance.notificationSuccess("Notificación eliminada");
});
