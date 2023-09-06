// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/firebase_config.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/config/generated/l10n.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:sqflite/sqflite.dart';
import 'config/DB/database.dart';
import 'presentation/providers/providers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'presentation/routes/app_router.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //se carga la clase con unica instancia de preferencias de usuario
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  /*  await PushNotificationService.initializeApp(
      DefaultFirebaseConfig.platformOptions); */
  //se cargan las preferencias de idioma

  runApp(ProviderScope(child: AppState()));
}

class AppState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(firebaseInitProvider(DefaultFirebaseConfig.platformOptions));

    return myApp();
  }
}

class myApp extends ConsumerStatefulWidget {
  myApp({Key? key}) : super(key: key);

  _myAppState createState() => _myAppState();
}

class _myAppState extends ConsumerState<myApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  var databaseFuture = DatabaseHelper.db.database;

  @override
  void initState() {
    PushNotificationService.messagesStream.listen((message) {
      print("message.notification!.title");
      print(message.notification!);
      get_notis(message);

      NotificationUI.instance.notificationAlert(
          message.notification!.title!, message.notification!.body!);
    });
    super.initState();
  }

  Future get_notis(RemoteMessage message) async {
    final Database database = await databaseFuture;
    const TABLE = "notificaciones";
    Batch batch = database.batch();
    batch.insert(TABLE, {
      'senderId': message.senderId.toString(),
      'category': message.category.toString(),
      'collapseKey': message.collapseKey.toString(),
      'contentAvailable': message.contentAvailable.toString(),
      'data': message.data.toString(),
      'fromD': message.from.toString(),
      'messageId': message.messageId.toString(),
      'messageType': message.messageType.toString(),
      'mutableContent': message.mutableContent.toString(),
      'title': message.notification?.title.toString() ?? "Sin titulo",
      'body': message.notification?.body.toString() ?? "Sin descripción",
      'sentTime': DateTime.now().toString(),
      'threadId': message.threadId.toString(),
      'ttl': message.ttl.toString(),
      'seen': "0"
    });
    batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'ICARM',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: NotificationService.messengerkey,
      routerConfig: appRouter,
      builder: BotToastInit(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
        LocaleNamesLocalizationsDelegate(),
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }
}
