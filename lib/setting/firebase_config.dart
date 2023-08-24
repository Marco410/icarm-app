import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:863743504248:ios:834986e01383385458e28d',
        apiKey: 'AIzaSyDFxYuaICnz-Hc9MsyFZz-2K-4Pp2unf9s',
        projectId: 'mtm-icar',
        messagingSenderId: '863743504248',
        iosBundleId: 'com.mtm.icarm',
        authDomain: 'mtm-icarm.appspot.com',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:863743504248:android:1ce3ce0654df343358e28d',
        apiKey: 'AIzaSyDqqXVEIYUFgkgKRreyC3UQdqnbN0ezi4g',
        projectId: 'mtm-icarm',
        messagingSenderId: '863743504248',
        authDomain: 'mtm-icarm.appspot.com',
      );
    }
  }
}
