import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:icarm/presentation/screens/home/main_home.dart';

import '../../presentation/components/drawer.dart';
import '../../presentation/screens/screens.dart';
import '../../presentation/screens/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => MainHome(), routes: [
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
  static void goHome(BuildContext context) {
    context.go('/home');
  }
}
