import 'dart:async';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/providers/radio_service.dart';
import 'package:icarm/presentation/screens/radio/widgets/radio_stream.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class RadioController {
  final AudioPlayer audioPlayer;
  final WidgetRef ref;
  final StreamHandler streamHandler;
  final bool mounted;

  RadioController({
    required this.audioPlayer,
    required this.ref,
    required this.streamHandler,
    required this.mounted,
  });

  void streamsRadio() async {
    ref.read(radioServiceProvider).playerStateStream.listen((state) async {
      switch (state.processingState) {
        case ProcessingState.buffering:
          /* onBuffering(); */
          break;

        case ProcessingState.ready:
          onReady();
          break;

        case ProcessingState.idle:
          onIdle();
          break;

        case ProcessingState.loading:
          onLoading();
          break;

        case ProcessingState.completed:
          break;

        default:
          break;
      }
    });

    ref.read(radioServiceProvider).playbackEventStream.listen((event) async {
      ref.read(dateBufferProvider.notifier).update((state2) => null);
      switch (event.processingState) {
        case ProcessingState.buffering:
          onBuffering(event.updateTime);
          break;

        case ProcessingState.ready:
          onReady();
          break;

        case ProcessingState.idle:
          break;

        case ProcessingState.loading:
          onLoading();
          break;

        case ProcessingState.completed:
          break;

        default:
          break;
      }
    });

    ref.read(radioServiceProvider).playingStream.listen((event) async {
      //set the icon when is playing or when stops
      ref.read(radioisPlayingProvider.notifier).update((state2) => event);
    });

    ref.read(radioServiceProvider).processingStateStream.listen((event) async {
      ref.watch(prosessionStateProvider.notifier).update((state) => event);
    });
  }

  Future<void> playRadio() async {
    if (await ConnectivityWrapper.instance.isConnected) {
    } else {
      NotificationUI.instance.notificationNoInternet();
      return;
    }

    try {
      final url = "https://stream.zeno.fm/5dsk2i7levzvv";

      audioPlayer.setUrl(
        url,
        preload: false,
        tag: MediaItem(
          id: '1',
          album: "Radio En Vivo",
          title: "Radio En Vivo | Amor & Restauración Morelia",
          artist: "Amor & Restauración Morelia",
          genre: 'Religious',
          artUri: Uri.parse(
              'https://zeno.fm/_next/image/?url=https%3A%2F%2Fimages.zeno.fm%2FoU_QTjtJrboK2rm3nPb8NiKuieHzoQuYg06OF-85A8U%2Frs%3Afit%3A240%3A240%2Fg%3Ace%3A0%3A0%2FaHR0cHM6Ly9zdHJlYW0tdG9vbHMuemVub21lZGlhLmNvbS9jb250ZW50L3N0YXRpb25zLzJmNjE2OTI2LTkzOGQtNDNmZC1iYjBiLTBiMDM0M2ExMmFhMS9pbWFnZS8_dXBkYXRlZD0xNzE5NDYwNDEyMDAw.webp&w=3840&q=100'),
          displayDescription: "Radio en vivo de la iglesia A&R Morelia",
          displayTitle: "Radio En Vivo | Amor & Restauración Morelia",
        ),
      );
      ref
          .read(radioServiceProvider)
          .setCanUseNetworkResourcesForLiveStreamingWhilePaused(true);

      AudioSession.instance.then((audioSession) async {
        await audioSession.configure(AudioSessionConfiguration.speech());
        _handleInterruptions(audioSession);
        await audioPlayer.play();
      });
      await Haptics.vibrate(HapticsType.success);
    } on PlayerException catch (e) {
      print("Error message: ${e.message}");
      stopRadio();
    } on PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
      stopRadio();
    } catch (e) {
      print('An error occured: $e');
      stopRadio();
    }
  }

  Future<void> stopRadio() async {
    await audioPlayer.stop();
    if (mounted) {
      ref.read(loadingStreamRadioProvider.notifier).update((state2) => false);
      ref.read(radioisPlayingProvider.notifier).update((state) => false);
    }
    streamHandler.stopStream();
  }

  void _handleInterruptions(AudioSession audioSession) {
    audioSession.becomingNoisyEventStream.listen((_) {
      stopRadio();
    });

    audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              audioPlayer.setVolume(audioPlayer.volume / 2);
            }
            break;
          case AudioInterruptionType.pause:
            if (audioPlayer.playing) {
              pauseRadio();
            }
          case AudioInterruptionType.unknown:
            if (audioPlayer.playing) {
              pauseRadio();
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            audioPlayer.setVolume(min(1.0, audioPlayer.volume * 2));
            break;
          case AudioInterruptionType.pause:
            resumeRadio();
            break;
          case AudioInterruptionType.unknown:
            resumeRadio();
            break;
        }
      }
    });
  }

  Future<void> pauseRadio() async {
    await audioPlayer.pause();
    ref.read(radioisPlayingProvider.notifier).update((state) => false);
  }

  Future<void> resumeRadio() async {
    await audioPlayer.play();
    ref.read(radioisPlayingProvider.notifier).update((state) => true);
  }

  Future<void> tryReconnect() async {
    stopRadio();
    Future.delayed(Duration(milliseconds: 500), () {
      playRadio();
    });
  }

  void onBuffering(DateTime timeBuffer) async {
    ref.read(loadingStreamRadioProvider.notifier).update((state2) => true);
    ref.read(dateBufferProvider.notifier).update((state2) => timeBuffer);
  }

  void onReady() {
    if (mounted) {
      ref.read(loadingStreamRadioProvider.notifier).update((state2) => false);
    }
  }

  void onIdle() {
    if (mounted) {}
  }

  void onLoading() {
    if (mounted) {
      ref.read(loadingStreamRadioProvider.notifier).update((state2) => true);
    }
  }
}
