import 'package:flutter/material.dart';
import 'package:icarm/presentation/screens/home/main_home.dart';
import 'package:icarm/presentation/screens/beteles/beteles.dart';

class PageRoutes {
  static const String home = 'home';
  static const String beteles = 'beteles';

  Map<String, WidgetBuilder> routes() {
    return {
      home: (context) => MainHome(),
      beteles: (context) => BetelesPage(),
    };
  }
}
