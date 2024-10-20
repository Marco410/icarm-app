// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/DB/database.dart';
import 'package:icarm/config/services/http_general_service.dart';
import 'package:icarm/config/setting/api.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';

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
  if (prefs.usuarioID == "" || prefs.ds_token_notificaciones == '') {
    return;
  }

  final Map<String, dynamic> registerUser = {
    "userId": prefs.usuarioID,
    "firebase_token": prefs.ds_token_notificaciones,
  };

  await BaseHttpService.basePost(
      url: UPDATE_FIREBASE_USER_URL,
      authorization: false,
      body: registerUser,
      showNoti: false);
});
var databaseFuture = DatabaseHelper.db.database;

class PushNotificationService {
  PushNotificationService() {}
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static StreamController<RemoteMessage> _messageStream =
      new StreamController.broadcast();

  static Stream<RemoteMessage> get messagesStream => _messageStream.stream;

  List<RemoteMessage> msjs = [];

  static Future _backgroudHandler(RemoteMessage message) async {
    _messageStream.add(message);
    return Future<void>.value();
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    _messageStream.add(message);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
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

  List<Map<String, dynamic>> notiSelected = [];

  List<Map<String, dynamic>> get notiSelectedGet => this.notiSelected;
}
