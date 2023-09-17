import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final audioPlayer = AudioPlayer();
final radioServiceProvider = StateProvider<AudioPlayer>((ref) {
  return audioPlayer;
});

final radioisPlayingProvider = StateProvider<bool>((ref) {
  return false;
});
