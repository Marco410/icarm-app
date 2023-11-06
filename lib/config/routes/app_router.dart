import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/models/kids/kidsModel.dart';

import 'package:icarm/presentation/screens/home/main_home.dart';
import 'package:icarm/presentation/screens/perfil/kids/kids.dart';
import 'package:icarm/presentation/screens/perfil/kids/kids_add.dart';
import 'package:icarm/presentation/screens/perfil/perfil.dart';

import '../../presentation/components/drawer.dart';
import '../../presentation/screens/perfil/notifications/noti_preview.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/screens/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => MainHome(), routes: [
      GoRoute(
          path: 'perfil',
          name: 'perfil',
          builder: (context, state) => PerfilPage(),
          routes: [
            GoRoute(
                path: 'notifications',
                name: 'notifications',
                builder: (context, state) => Notifications(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    name: 'notiPreview',
                    builder: (context, state) => NotiPreviewPage(),
                  ),
                ]),
            GoRoute(
                name: 'kids',
                path: 'kids',
                builder: (context, state) => KidsPage(),
                routes: [
                  GoRoute(
                    name: 'kidsAdd',
                    path: 'new:type',
                    builder: (context, state) {
                      String? ty = state.pathParameters['type'];
                      Kid kid = Kid(
                          id: 0,
                          userId: 0,
                          nombre: "",
                          aPaterno: "aPaterno",
                          aMaterno: "",
                          fechaNacimiento: DateTime.now(),
                          createAt: DateTime.now(),
                          sexo: "",
                          enfermedad: "",
                          active: 1);

                      if (ty == 'edit') {
                        kid = state.extra as Kid;
                      }

                      return KidsAddPage(
                        type: ty!,
                        kid: kid,
                      );
                    },
                  ),
                ]),
          ]),
      GoRoute(
          path: 'qr',
          name: 'qr',
          builder: (context, state) => QRPage(),
          routes: [
            GoRoute(
                path: 'scanner',
                name: 'scanner',
                builder: (context, state) {
                  return QRScanner();
                }),
            GoRoute(
                path: 'confirm',
                name: 'confirm',
                builder: (context, state) {
                  return QRConfirm();
                })
          ]),
      GoRoute(
          path: 'event',
          name: 'event',
          builder: (context, state) {
            Event event = state.extra as Event;
            return EventScreen(
              event: event,
            );
          })
    ]),
  ]);
});

class NavigationRoutes {
  static void goLogin(BuildContext context) {
    context.go('/login');
  }

  static void goRegister(BuildContext context) {
    context.push('/register');
  }

  static void goHome(BuildContext context) {
    context.go('/home');
  }

  static void goPerfil(BuildContext context) {
    context.push('/home/perfil');
  }
}
