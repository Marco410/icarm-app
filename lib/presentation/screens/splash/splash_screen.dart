import 'dart:async';

import 'package:flutter/material.dart';
import '../../../config/routes/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    return Timer(const Duration(milliseconds: 4500), navigatorPage);
  }

  Future<void> navigatorPage() async {
    NavigationRoutes.goHome(context);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/image/logo.png", height: 120.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
