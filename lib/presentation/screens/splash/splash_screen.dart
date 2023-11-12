import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
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
    const storage = FlutterSecureStorage();
    final prefs = PreferenciasUsuario();
    print("prefs.usuarioID");
    print(prefs.usuarioID);
    print("prefs.token");
    String token = (await storage.read(key: "tokenAuth")) ?? '';
    print(token);

    if (prefs.usuarioID != "" && token.isNotEmpty) {
      NavigationRoutes.goHome(context);
    } else {
      NavigationRoutes.goLogin(context);
    }
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
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
              Color.fromRGBO(0, 0, 0, 0.1),
              Color.fromRGBO(0, 0, 0, 0.1)
            ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/image/logo.png", height: 150.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
