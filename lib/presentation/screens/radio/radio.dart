import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:icarm/config/helpers/link_helper.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/radio_controller.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:icarm/presentation/screens/radio/comments.dart';
import 'package:icarm/presentation/screens/radio/widgets/radio_stream.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

import 'package:icarm/config/setting/style.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer_pro/sizer.dart';
import '../../components/zcomponents.dart';

class RadioPage extends ConsumerStatefulWidget {
  const RadioPage({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<RadioPage> createState() => _RadioPageState();
}

/* Radio Tests:
  1. User play
  2. User pause
  3. User stop
  4. User has no connection
  5. User has internet connection
  6. User is listen and lost connection
  7. User is listen and lost connection then in 3 seconds is reconnecting
  8. User is listen and lost connection then in 8 seconds is reconnecting
  8. User is listen and lost connection then in 12 seconds is reconnecting
  9. User is listen and lost connection then in 15 seconds is reconnecting
  9. User is listen and lost connection then in 20 seconds is reconnecting
  9. User is listen and lost connection then in 23 seconds is reconnecting
  9. User is listen and lost connection then in 24 seconds is reconnecting
  9. User is listen and lost connection then in 25 seconds is reconnecting
  9. User is listen and lost connection then in 30 seconds is reconnecting
 */
class _RadioPageState extends ConsumerState<RadioPage>
    with WidgetsBindingObserver {
  bool loading = false;
  final CarouselSliderController _controllerC = CarouselSliderController();
  int _current = 0;
  int connectionTrys = 0;
  String currentSong = "";
  final commnetKey = new GlobalKey();
  final streamHandler = StreamHandler();

  double scrollPosition = 0;
  final _scrollController = ScrollController();
  final HtmlEditorController editorController = HtmlEditorController(
      toolbarOptions: HtmlToolbarOptions(
          textStyle: TxtStyle.labelText,
          toolbarPosition: ToolbarPosition.custom));
  late RadioController radioController;

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

  void initState() {
    radioController = RadioController(
        audioPlayer: audioPlayer,
        ref: ref,
        streamHandler: streamHandler,
        mounted: mounted);

    radioController.streamsRadio();

    _scrollController.addListener(() {
      setState(() {
        scrollPosition = _scrollController.offset;
      });

      if (scrollPosition > 100) {
        editorController.clearFocus();
      }
    });

    if (editorController.initialized) {
      editorController.initEditor(context);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    editorController.dispose();
    _scrollController.dispose();
  }

  void scrollTop() {
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 600), curve: Curves.ease);
  }

  Future<void> onRefresh() async {
    radioController.tryReconnect();
  }

  @override
  Widget build(BuildContext context) {
    final radioIsPlaying = ref.watch(radioisPlayingProvider);
    final loadingStreamRadio = ref.watch(loadingStreamRadioProvider);
    final prosessionState = ref.watch(prosessionStateProvider);
    final dateBuffer = ref.watch(dateBufferProvider);

    // This function catch when user lost connection
    // When user lost connection loadingStream === true, processiongState is === buffering
    // and dateBuffer is != null
    // when pass more than 25 seconds radio will stop
    if (loadingStreamRadio &&
        prosessionState == ProcessingState.buffering &&
        dateBuffer != null) {
      Duration seg = DateTime.now().difference(dateBuffer);

      if (seg.inSeconds > 25) {
        radioController.stopRadio();
      }
    }

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
                          color: ColorStyle.primaryColor, fontSize: 9.f),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CarouselWidget(
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
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FadedScaleAnimation(
                                child: Text(
                                    "Una palabra, puede cambiar tu vida.",
                                    textAlign: TextAlign.center,
                                    style: TxtStyle.labelText.copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 7.f)),
                              ),
                              (!radioIsPlaying && loadingStreamRadio)
                                  ? Text('En vivo las 24 hrs.',
                                      textAlign: TextAlign.center,
                                      style: TxtStyle.labelText)
                                  : SizedBox(),
                              Text(
                                  'Todos nuestros programas se guardan en todas nuestras plataformas, no te los pierdas.',
                                  textAlign: TextAlign.center,
                                  style: TxtStyle.labelText
                                      .copyWith(fontWeight: FontWeight.normal)),
                              (!radioIsPlaying && loadingStreamRadio)
                                  ? Text(
                                      'Puede tardar algunos segundos en empezar.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 6.f,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(),
                              (radioIsPlaying && !loadingStreamRadio)
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
                                                          fontSize: 6.5.f),
                                                );
                                              }
                                            })
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          height: 3.5,
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
                                              fontSize: 5.5.f,
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
                        Container(
                          margin: EdgeInsets.only(right: 0),
                          child: Bounceable(
                            onTap: () {
                              Share.share(
                                "💒 ¡Descarga nuestra app! 📱\n\n Conéctate con nuestra comunidad, accede a eventos, podcast, radio, mensajes y más desde cualquier lugar. 🌎\n\n ${LinkHelper.linkApp()}",
                                subject: '¡Comparte la aplicación! 📱',
                              );
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
                                Icons.share_rounded,
                                color: ColorStyle.secondaryColor,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PlayButtonRadio(
                              radioIsPlaying: radioIsPlaying,
                              radioController: radioController,
                              loadingStreamRadio: loadingStreamRadio,
                              connection: true,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(),
                          margin: EdgeInsets.only(right: 0),
                          child: Bounceable(
                            onTap: () {
                              editorController.setFocus();
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

class PlayButtonRadio extends StatelessWidget {
  const PlayButtonRadio(
      {super.key,
      required this.radioIsPlaying,
      required this.radioController,
      required this.loadingStreamRadio,
      required this.connection});

  final bool radioIsPlaying;
  final RadioController radioController;
  final bool loadingStreamRadio;
  final bool connection;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: () async {
        if (radioIsPlaying) {
          radioController.stopRadio();
        } else {
          radioController.playRadio();
        }
      },
      child: Container(
        height: 45.sp,
        width: 45.sp,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            color: ColorStyle.whiteBacground,
            border: Border.all(width: 8, color: Colors.black),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 11,
                  spreadRadius: 1,
                  offset: Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(100)),
        child: (!connection)
            ? Icon(
                Icons.wifi_off_rounded,
                size: 22.sp,
                color: ColorStyle.primaryColor,
              )
            : (loadingStreamRadio)
                ? SizedBox(
                    height: 25.sp,
                    width: 25.sp,
                    child: LoadingStandardWidget.loadingWidget())
                : Icon(
                    radioIsPlaying ? Icons.pause : Icons.play_arrow,
                    size: 25.sp,
                    color: ColorStyle.primaryColor,
                  ),
      ),
    );
  }
}
