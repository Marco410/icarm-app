import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/DB/database.dart';
import 'package:icarm/config/services/http_general_service.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/providers/notification_provider.dart';
import 'package:sqflite/sqflite.dart';

final prefs = new PreferenciasUsuario();

final firebaseInitProvider =
    FutureProvider.family<void, FirebaseOptions>((ref, options) async {
  String? token;
  await Firebase.initializeApp(name: "mtm-icarm", options: options);

  if (Platform.isIOS) {
    await PushNotificationService.requestPermission();
  }
  token = await FirebaseMessaging.instance.getToken();
  //este token es para cada dispositivo
  print("token");
  print(token);
  prefs.ds_token_notificaciones = token!;

  ref.read(updateFirebaseTokenProvider);

  //Handlers
  FirebaseMessaging.onBackgroundMessage(
      PushNotificationService._backgroudHandler);
  FirebaseMessaging.onMessage.listen(PushNotificationService._onMessageHandler);
  FirebaseMessaging.onMessageOpenedApp
      .listen(PushNotificationService._onMessageOpenApp);
});

final updateFirebaseTokenProvider = FutureProvider<void>((ref) async {
  final Map<String, dynamic> registerUser = {
    "userId": prefs.usuarioID,
    "firebase_token": prefs.ds_token_notificaciones,
  };

  await BaseHttpService.basePost(
      url: UPDATE_FIREBASE_USER_URL, authorization: false, body: registerUser);
});
var databaseFuture = DatabaseHelper.db.database;

class PushNotificationService {
  PushNotificationService() {
    this.get_local_notifications();
  }
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static StreamController<RemoteMessage> _messageStream =
      new StreamController.broadcast();

  static Stream<RemoteMessage> get messagesStream => _messageStream.stream;
  var databaseFuture = DatabaseHelper.db.database;
  Map<String, dynamic> args = {};
  Map<String, dynamic> get argsGet => this.args;
  set argsSet(Map<String, dynamic> valor) {
    this.args = valor;
  }

  List<RemoteMessage> msjs = [];

  static Future _backgroudHandler(RemoteMessage message) async {
    //cuando la aplicacion esta terminada
    //print('on backgroud Handler ${message.messageId}');
    _messageStream.add(message);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStream.add(message);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('on Message Open App Handler ${message.messageId}');
    print("_onMessageOpenApp");
    print(message);
    _messageStream.add(message);
  }

  //Apple
  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push noti status ${settings.authorizationStatus}');
  }

  static clodeStreams() {
    _messageStream.close();
  }

  List<Map<String, Object?>> notis = [];

  List<Map<String, Object?>> get notisGet => this.notis;

  bool newNoti = false;
  bool get newNotiGet => this.newNoti;

  get_local_notifications() async {
    final Database database = await databaseFuture;
    const TABLE = "notificaciones";

    final notisMap = await database.query(
      TABLE,
      orderBy: "id DESC",
    );

    this.notis = [];
    this.notis = notisMap.toList();
    this.newNoti = this.notis.any((element) => element['seen'] == "0");
  }

  List<Map<String, dynamic>> notiSelected = [];

  List<Map<String, dynamic>> get notiSelectedGet => this.notiSelected;

  get_noti(noti_id) async {
    final Database database = await databaseFuture;
    const TABLE = "notificaciones";

    var getDataPaused = await database.query(TABLE, where: 'id = "$noti_id"');

    await database.update(TABLE, {'seen': "1"}, where: 'id = "$noti_id"');

    this.notiSelected = getDataPaused;
    get_local_notifications();
  }

  delete_noti(noti_id) async {
    final Database database = await databaseFuture;
    const TABLE = "notificaciones";

    await database.delete(TABLE, where: 'id = "$noti_id"');

    get_local_notifications();
  }
}
