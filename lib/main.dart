// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:icarm/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icarm/screen/splash/splash_screen.dart';
import 'package:icarm/services/notification_service.dart';
import 'package:icarm/services/page_service.dart';
import 'package:icarm/services/push_notifications_service.dart';
import 'package:icarm/services/radio_service.dart';
import 'package:icarm/setting/firebase_config.dart';

import 'package:icarm/share_prefs/prefs_usuario.dart';
import 'package:provider/provider.dart';
import 'package:icarm/generated/l10n.dart';

import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'package:icarm/screen/screens.dart';
import 'package:sqflite/sqflite.dart';

import 'DB/database.dart';

/// Run first apps open
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //se carga la clase con unica instancia de preferencias de usuario
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  await PushNotificationService.initializeApp(
      DefaultFirebaseConfig.platformOptions);
  //se cargan las preferencias de idioma

  //Cargar el archivo de configuraciones en assets/cfg
  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => RadioService()),
      ChangeNotifierProvider(create: (_) => PushNotificationService()),
      ChangeNotifierProvider(create: (_) => PageService()),
    ], child: myApp());
  }
}

class myApp extends StatefulWidget {
  myApp({Key? key}) : super(key: key);

  _myAppState createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  late ThemeBloc _themeBloc;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  var databaseFuture = DatabaseHelper.db.database;
  PushNotificationService? notiService = PushNotificationService();

  @override
  void initState() {
    PushNotificationService.messagesStream.listen((message) {
      print("message.notification!.title");
      print(message.notification!.title);
      get_notis(message);

      NotificationService.showSnackBarSuccess("Nueva notificación", context);

      final snackBar = SnackBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 5.0,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
              label: "Ver",
              textColor: Colors.white,
              onPressed: () {
                //navigatorKey.currentState!.pushNamed(PageRoutes.noti);
              }),
          content: Text(
              "Nueva notificación: " + message.notification!.title.toString()));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
    super.initState();
    _themeBloc = ThemeBloc();
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
    return StreamBuilder<ThemeData>(
      initialData: _themeBloc.initialTheme().data,
      stream: _themeBloc.themeDataStream,
      builder: (BuildContext context, AsyncSnapshot<ThemeData> snapshot) {
        return MaterialApp(
          title: 'ICARM',
          theme: snapshot.data,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: NotificationService.messengerkey,
          home: SplashScreen(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            S.delegate,
            LocaleNamesLocalizationsDelegate(),
          ],
          supportedLocales: S.delegate.supportedLocales,
          routes: PageRoutes().routes(),
        );
      },
    );
  }
}
