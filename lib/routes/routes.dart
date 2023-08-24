import 'package:flutter/material.dart';
import 'package:icarm/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:icarm/screen/beteles/beteles.dart';

class PageRoutes {
  static const String home = 'home';
  static const String beteles = 'beteles';

  Map<String, WidgetBuilder> routes() {
    return {
      home: (context) => bottomNavBar(),
      beteles: (context) => BetelesPage(),
    };
  }
}
