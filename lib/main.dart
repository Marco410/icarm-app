// ignore_for_file: must_be_immutable, unused_result
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/firebase_config.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/config/generated/l10n.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:sizer_pro/sizer.dart';
import 'presentation/providers/notification_provider.dart';
import 'presentation/providers/providers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'config/routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

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

class _myAppState extends ConsumerState<myApp> with WidgetsBindingObserver {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  double? _originalBrightness;

  @override
  void initState() {
    PushNotificationService.messagesStream.listen((message) {
      ref.refresh(storeNotificationProvider(message));

      NotificationUI.instance.notificationAlert(
          message.notification!.title!, message.notification!.body!);
    });

    WidgetsBinding.instance.addObserver(this);
    brightnessFunc();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ScreenBrightness().setScreenBrightness(_originalBrightness!);
    super.dispose();
  }

  void brightnessFunc() async {
    _originalBrightness = await ScreenBrightness().current;
    await ScreenBrightness().setScreenBrightness(_originalBrightness!);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      brightnessFunc();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    return Sizer(builder: (context, orientation, deviceType) {
      return ConnectivityAppWrapper(
        app: MaterialApp.router(
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
        ),
      );
    });
  }
}
