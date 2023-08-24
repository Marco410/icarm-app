//import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icarm/share_prefs/prefs_usuario.dart';

class RadioService extends ChangeNotifier {
  final prefs = new PreferenciasUsuario();
  final storage = new FlutterSecureStorage();

  RadioService() {}

  final audioPlayer = AudioPlayer();
  AudioPlayer get audioPlayerGet => this.audioPlayer;

  bool isPlaying = false;
  bool get isPlayingGet => this.isPlaying;
  set isPlayingSet(bool valor) {
    this.isPlaying = valor;
    notifyListeners();
  }
}
