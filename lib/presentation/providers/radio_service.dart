//import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';

class RadioService extends ChangeNotifier {
  final prefs = new PreferenciasUsuario();

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
