// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:icarm/setting/style.dart';

import '../../services/page_service.dart';

class home extends StatefulWidget {
  home();

  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  bool loadCard = true;
  bool loading = true;
  Future delayedLoading = Future(() => null);

  late VideoPlayerController _controller;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  _homeState();

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
    return FadedSlideAnimation(
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.27,
                child: (loading)
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorStyle.primaryColor.withOpacity(0.2),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: -16,
                                offset: Offset(0, -1))
                          ],
                        ),
                        child: _controller.value.isInitialized
                            ? ClipRRect(
                                child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        Colors.black12, BlendMode.darken),
                                    child: VideoPlayer(_controller)),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)))
                            : Container(),
                      ),
              ),
              /*     Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      FadedScaleAnimation(
                        child: FractionalTranslation(
                          translation: Offset(-0.53, -1.00),
                          child: Text(
                            "Amor &",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      FadedScaleAnimation(
                        child: FractionalTranslation(
                          translation: Offset(-0.089, -0.05),
                          child: Text(
                            "Restauración",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: colorStyle.secondaryColor,
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), */
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
                        onTap: () {
                          final pageService =
                              Provider.of<PageService>(context, listen: false);

                          setState(() {
                            pageService.currentPageSet = 4;
                          });
                          Navigator.pushReplacementNamed(
                              context, PageRoutes.home);
                        },
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
                    borderRadius: BorderRadius.circular(15),
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
                      color: colorStyle.secondaryColor,
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
              color: Colors.black87, borderRadius: BorderRadius.circular(20)),
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13),
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: colorStyle.primaryColor,
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.calendar_month_rounded,
              color: colorStyle.secondaryColor.withOpacity(1),
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
