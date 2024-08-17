import 'dart:async';
import 'dart:math';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:audio_session/audio_session.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:icarm/presentation/screens/radio/comments.dart';
import 'package:icarm/presentation/screens/radio/widgets/radio_stream.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:lottie/lottie.dart';

import 'package:icarm/config/setting/style.dart';
import 'package:sizer_pro/sizer.dart';
import '../../components/zcomponents.dart';

class RadioPage extends ConsumerStatefulWidget {
  const RadioPage({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends ConsumerState<RadioPage>
    with WidgetsBindingObserver {
  bool loading = false;
  final CarouselController _controllerC = CarouselController();
  int _current = 0;
  bool loadingStreamRadio = false;
  int connectionTrys = 0;
  String currentSong = "";
  final commnetKey = new GlobalKey();
  final streamHandler = StreamHandler();

  FocusNode commentField = FocusNode();
  double scrollPosition = 0;
  final _scrollController = ScrollController();
  final HtmlEditorController editorController = HtmlEditorController(
      toolbarOptions: HtmlToolbarOptions(
          textStyle: TxtStyle.labelText,
          toolbarPosition: ToolbarPosition.custom));
  List<Widget> textItems = [
    ContentAdWidget(
      image: "assets/image/home/hombres-radio.jpeg",
      title: "Hombres Valientes",
      subTitle: "Martes 6:00pm",
      actionButton: () {},
    ),
    ContentAdWidget(
      image: "assets/image/home/mujeres-radio.jpeg",
      title: "Mujeres Entendidas",
      subTitle: "Jueves 5:30pm",
      actionButton: () {},
    ),
    ContentAdWidget(
      image: "assets/image/home/jovenes-radio.jpeg",
      title: "Jóvenes de Influencia",
      subTitle: "Jueves 7:00pm",
      actionButton: () {},
    ),
    ContentAdWidget(
      image: "assets/image/home/noches.png",
      title: "Noches de Restauración",
      subTitle: "Sábados",
      actionButton: () {},
    ),
    ContentAdWidget(
      image: "assets/image/home/podcast.png",
      title: "Escucha nuestro podcast",
      subTitle: "Podcast",
      actionButton: () {},
    ),
    ContentAdWidget(
      image: "assets/image/home/online.png",
      title: "Transmisiones en vivo",
      subTitle: "Predicas online",
      actionButton: () {},
    ),
  ];

  void onBuffering() {
    if (mounted) {
      ref.read(radioisPlayingProvider.notifier).update((state2) => false);
      setState(() {
        loadingStreamRadio = true;
      });
    }
    Future.delayed(Duration(seconds: 3), () async {
      if (loadingStreamRadio) {
        await tryReconnect();
      }

      Future.delayed(Duration(seconds: 8), () async {}).whenComplete(() {
        if (loadingStreamRadio) {
          tryReconnect();
        }
      });
    });
  }

  void onReady() {
    if (mounted) {
      ref.read(radioisPlayingProvider.notifier).update((state2) => true);
      setState(() {
        loadingStreamRadio = false;
      });
    }
  }

  void onIdle() {
    if (mounted) {
      ref.read(radioisPlayingProvider.notifier).update((state2) => false);
    }
  }

  void onLoading() {}

  void initState() {
    ref.read(radioServiceProvider).playerStateStream.listen((state) async {
      switch (state.processingState) {
        case ProcessingState.buffering:
          onBuffering();
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
      switch (event.processingState) {
        case ProcessingState.buffering:
          /*  if (Platform.isAndroid) {
            await tryReconnect();
          } */
          break;

        case ProcessingState.ready:
          if (mounted) {
            setState(() {
              loadingStreamRadio = false;
            });
          }
          break;

        case ProcessingState.idle:
          break;

        case ProcessingState.loading:
          if (mounted) {
            setState(() {
              loadingStreamRadio = true;
            });
          }
          break;

        case ProcessingState.completed:
          break;

        default:
          break;
      }
    });

    _scrollController.addListener(() {
      setState(() {
        scrollPosition = _scrollController.offset;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Future<void> tryReconnect() async {
    stopRadio();

    Future.delayed(Duration(milliseconds: 500), () {
      playRadio();
    });
  }

  Future<void> playRadio() async {
    if (await ConnectivityWrapper.instance.isConnected) {
    } else {
      NotificationUI.instance.notificationNoInternet();

      setState(() {
        connectionTrys++;
      });

      return;
    }

    try {
      // await AudioPlayer.clearAssetCache();
      final url = "https://stream.zeno.fm/5dsk2i7levzvv";

      //http://stream.zeno.fm/5dsk2i7levzvv
      //final uri = Uri.parse(url);

      /*  final audioSource = LockCachingAudioSource(
        uri,
      ); */
      //audioPlayer.setAudioSource(audioSource);

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
      //await audioSource.clearCache();

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
    audioSession.devicesChangedEventStream.listen((event) {
      print('Devices added: ${event.devicesAdded}');
      print('Devices removed: ${event.devicesRemoved}');
    });

    audioSession.configurationStream
        .map((conf) => conf.androidAudioAttributes)
        .distinct()
        .listen((attributes) {});
  }

  Future<void> pauseRadio() async {
    await audioPlayer.pause();
    ref.read(radioisPlayingProvider.notifier).update((state) => false);
  }

  Future<void> resumeRadio() async {
    await audioPlayer.play();
    ref.read(radioisPlayingProvider.notifier).update((state) => true);
  }

  Future<void> stopRadio() async {
    await audioPlayer.stop();
    ref.read(radioisPlayingProvider.notifier).update((state) => false);
    streamHandler.stopStream();
  }

  void scrollTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  Future<void> onRefresh() async {
    tryReconnect();
  }

  @override
  Widget build(BuildContext context) {
    final radioIsPlaying = ref.watch(radioisPlayingProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        editorController.clearFocus();
      },
      child: Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (scrollPosition > 100)
                ? FadedScaleAnimation(
                    child: InkWell(
                      onTap: () => scrollTop(),
                      child: Container(
                        height: 20.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                            color: ColorStyle.primaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
        body: FadedSlideAnimation(
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: Container(
            padding: EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Text(
                      "A&R Radio - En vivo",
                      style: TxtStyle.headerStyle.copyWith(
                          color: ColorStyle.primaryColor, fontSize: 9.sp),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CarouselWidget(
                        textItems: textItems,
                        controller: _controllerC,
                        current: _current,
                        size: 90.sp,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        image: "assets/image/home/iglesia.png",
                        mainColor: ColorStyle.primaryColor),
                    SizedBox(
                      height: 20.h,
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FadedScaleAnimation(
                                child: Text(
                                    "Una palabra, puede cambiar tu vida.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 6.sp,
                                        fontWeight: FontWeight.normal)),
                              ),
                              Text(
                                'Puede tardar algunos segundos en empezar.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 4.sp,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              (radioIsPlaying)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Lottie.network(
                                            "https://assets7.lottiefiles.com/packages/lf20_eN8m772nQj.json",
                                            height: 50),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        StreamBuilder<String>(
                                            stream: streamHandler
                                                .currentSongStream(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData ||
                                                  snapshot.data == " - ") {
                                                return Container(
                                                    width: 30.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6,
                                                            horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color:
                                                            Colors.redAccent),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .circle_rounded,
                                                            color: Colors.white,
                                                            size: 15),
                                                        SizedBox(width: 5),
                                                        Text("En vivo",
                                                            style: TxtStyle
                                                                .labelText
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white)),
                                                      ],
                                                    ));
                                              } else {
                                                String currentSong = snapshot
                                                        .data ??
                                                    ' Radio En Vivo | Amor & Restauración Morelia ';
                                                return AutoScrollText(
                                                  currentSong + '    ',
                                                  curve: Curves.linear,
                                                  velocity: Velocity(
                                                      pixelsPerSecond:
                                                          Offset(30, 30)),
                                                  style: TxtStyle.labelText
                                                      .copyWith(
                                                          fontSize: 6.5.sp),
                                                );
                                              }
                                            })
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          height: 4,
                                          decoration: BoxDecoration(
                                              color: ColorStyle.secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Da clic en el botón de play para reproducir.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 5.sp,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 60,
                        ),
                        Bounceable(
                          onTap: () async {
                            if (radioIsPlaying) {
                              stopRadio();
                            } else {
                              playRadio();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: ColorStyle.whiteBacground,
                                border:
                                    Border.all(width: 8, color: Colors.black),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 11,
                                      spreadRadius: 1,
                                      offset: Offset(0, 0))
                                ],
                                borderRadius: BorderRadius.circular(100)),
                            child: (loadingStreamRadio)
                                ? SizedBox(
                                    height: 25.sp,
                                    width: 25.sp,
                                    child:
                                        LoadingStandardWidget.loadingWidget())
                                : Icon(
                                    radioIsPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 25.sp,
                                    color: ColorStyle.primaryColor,
                                  ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.only(right: 20),
                          alignment: Alignment.centerRight,
                          child: Bounceable(
                            onTap: () {
                              FocusScope.of(context).requestFocus(commentField);
                              Scrollable.ensureVisible(
                                  commnetKey.currentContext!,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeOut);
                            },
                            child: Container(
                              height: 51,
                              width: 51,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorStyle.secondaryColor,
                                      width: 3.5),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Icon(
                                Icons.comment_outlined,
                                color: ColorStyle.secondaryColor,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommentsScreenWidget(
                      editorController: editorController,
                      commentField: commentField,
                      commnetKey: commnetKey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
