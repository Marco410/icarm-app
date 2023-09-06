// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/carousel_widget.dart';
import 'package:icarm/presentation/components/components.dart';
import 'package:icarm/presentation/components/content_ad_widget.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/video_home_widget.dart';
import 'package:icarm/presentation/providers/youtube_provider.dart';
import 'package:icarm/presentation/routes/routes.dart';
import 'package:video_player/video_player.dart';
import 'package:icarm/config/setting/style.dart';

class Home extends ConsumerStatefulWidget {
  Home();

  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool loadCard = true;
  bool loading = true;
  Future delayedLoading = Future(() => null);

  late VideoPlayerController _controller;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  _HomeState();

  final CarouselController _controllerC = CarouselController();
  int _current = 2;

  @override
  void initState() {
    _controller = VideoPlayerController.asset(
      'assets/video/inicio.mp4',
    )
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
      });

    try {
      delayedLoading = Future.delayed(Duration(milliseconds: 1300), () {
        setState(() {
          loading = false;
        });
      });
    } catch (e) {}

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    ref.watch(liveProvider);
    final lives = ref.watch(isLiveProvider);

    List<Widget> textItems = [
      VideoHomeWidget(loading: loading, controller: _controller),
      ContentAdWidget(
        image: "assets/image/home/refugio.png",
        title: "Centros de restauración",
        subTitle: "Conócelos",
        buttonText: "Ver más",
        actionButton: () {},
      ),
      ContentAdWidget(
        image: "assets/image/home/iglesia.png",
        title: "Bienvenidos",
        subTitle: "A&R Morelia",
        buttonText: "Conócenos",
        actionButton: () {
          Navigator.pushReplacementNamed(context, PageRoutes.home);
        },
      ),
      ContentAdWidget(
        image: "assets/image/home/podcast.png",
        title: "Escucha nuestro podcast",
        subTitle: "Podcast",
        buttonText: "Escuchalo",
        actionButton: () {},
      ),
      ContentAdWidget(
        image: "assets/image/home/online.png",
        title: "Transmisiones en vivo",
        subTitle: "Predicas online",
        buttonText: "Ver más",
        actionButton: () {},
      ),
    ];

    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return FadedSlideAnimation(
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        height: mediaHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              (lives.length != 0)
                  ? YoutubeLiveBannerWidget(lives: lives)
                  : SizedBox(),
              Image.asset(
                "assets/image/home/event.jpg",
              ),
              Container(
                height: mediaHeight,
                width: mediaWidth,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/image/home/fotoportada.jpg"),
                        fit: BoxFit.cover)),
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 180, horizontal: 35),
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.7),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¡Bienvenidos!",
                          style: TxtStyle.headerStyle,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Somos una iglesia que busca hacer de cada persona un siervo líder, fiel, capaz y comprometido con Dios, que adquiera y reproduzca el carácter de Jesús en otras personas",
                          style: TxtStyle.descriptionStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        CustomButton(
                          text: "Ver predicaciones",
                          loading: false,
                          color: Colors.white,
                          onTap: () {},
                        )
                      ],
                    )),
              ),
              CarouselWidget(
                  textItems: textItems,
                  controller: _controllerC,
                  current: _current,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  image: "assets/image/home/iglesia.png",
                  mainColor: ColorStyle.primaryColor),
              Container(
                height: 45,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    FadedScaleAnimation(
                      child: LinkWidget(
                        text: 'Online',
                      ),
                    ),
                    FadedScaleAnimation(
                      child: LinkWidget(
                        onTap: () {},
                        text: 'Beteles',
                      ),
                    ),
                    FadedScaleAnimation(
                      child: LinkWidget(
                        text: 'Banco de Alimentos',
                      ),
                    ),
                    FadedScaleAnimation(
                      child: LinkWidget(
                        text: 'Retiro de Transformación',
                      ),
                    ),
                    FadedScaleAnimation(
                      child: LinkWidget(
                        text: 'Refugios',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        colorFilter:
                            ColorFilter.mode(Colors.black54, BlendMode.darken),
                        image: AssetImage("assets/image/home/iglesia.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FadedScaleAnimation(
                        child: Text(
                          "Bienvenidos",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(top: 15, left: 15),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Nuestros Horarios",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 26,
                      color: ColorStyle.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                            child: FadedScaleAnimation(
                              child: HorarioWidget(
                                horario: "7:15pm",
                                tipo: "General",
                                dia: 'Miércoles',
                              ),
                            ))),
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                            child: FadedScaleAnimation(
                              child: HorarioWidget(
                                horario: "6:00pm",
                                tipo: "Jóvenes",
                                dia: 'Viernes',
                              ),
                            ))),
                    Expanded(
                        flex: 2,
                        child: Container(
                            margin: EdgeInsets.only(top: 10, right: 5, left: 5),
                            child: FadedScaleAnimation(
                              child: HorarioWidget(
                                horario: "11:15am",
                                tipo: "General",
                                dia: 'Domingo',
                              ),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  String text;
  void Function()? onTap;
  LinkWidget({Key? key, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.black87, borderRadius: BorderRadius.circular(13)),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          )),
    );
  }
}

class HorarioWidget extends StatelessWidget {
  HorarioWidget(
      {Key? key, required this.dia, required this.horario, required this.tipo})
      : super(key: key);

  final String dia;
  final String horario;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.only(top: 10, bottom: 20, right: 10, left: 10),
      decoration: BoxDecoration(
          color: ColorStyle.primaryColor,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: -1,
                offset: Offset(0, 0))
          ],
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.calendar_month_rounded,
              color: ColorStyle.secondaryColor.withOpacity(1),
            ),
          ),
          Column(
            children: [
              Text(
                horario,
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
              Text(
                dia,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.church_rounded,
                color: Colors.white,
              ),
              Text(
                tipo,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
