import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final audioPlayer = AudioPlayer(
  handleInterruptions: false,
  androidApplyAudioAttributes: true,
  handleAudioSessionActivation: false,
);

final radioServiceProvider = StateProvider<AudioPlayer>((ref) {
  return audioPlayer;
});

final radioisPlayingProvider = StateProvider<bool>((ref) {
  return false;
});
