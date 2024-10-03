// ignore_for_file: must_be_immutable, unused_result

import 'dart:async';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/carousel_widget.dart';
import 'package:icarm/presentation/components/components.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:icarm/presentation/providers/youtube_provider.dart';
import 'package:icarm/presentation/screens/home/skeleton_home.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:icarm/config/setting/style.dart';

import '../../providers/home_provider.dart';

class Home extends ConsumerStatefulWidget {
  Home();

  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool loadCard = true;
  bool loading = false;
  Future delayedLoading = Future(() => null);

  late VideoPlayerController _controllerHomeVideo;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  _HomeState();

  final CarouselSliderController _controllerC = CarouselSliderController();
  int _current = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      loading = true;
    });

    _controllerHomeVideo = VideoPlayerController.asset(
      'assets/video/home.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controllerHomeVideo.addListener(() {
      setState(() {});
    });
    _controllerHomeVideo.setLooping(true);
    _controllerHomeVideo.initialize().then((_) {
      _controllerHomeVideo.setVolume(0);
      _controllerHomeVideo.play();
    });

    ref.refresh(getEventosProvider("user"));

    Future.microtask(() {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controllerHomeVideo.dispose();
    super.dispose();
  }

  final prefs = new PreferenciasUsuario();

  Widget build(BuildContext context) {
    final lives = ref.watch(isLiveProvider);
    final listEventos = ref.watch(listEventosProvider);

    final mediaHeight = MediaQuery.of(context).size.height;
    final eventoFavorite = ref.watch(eventoFavoriteProvider);
    return FadedSlideAnimation(
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        height: mediaHeight,
        child: RefreshIndicator(
          color: ColorStyle.secondaryColor,
          onRefresh: () => refreshHome(ref),
          child: SingleChildScrollView(
            child: Column(
              children: [
                (lives.length != 0)
                    ? YoutubeLiveBannerWidget(lives: lives)
                    : SizedBox(),
                (eventoFavorite != null)
                    ? GestureDetector(
                        onTap: () => context.pushNamed('event',
                            pathParameters: {
                              "eventoID": eventoFavorite.id.toString()
                            }),
                        child: Hero(
                          tag: eventoFavorite.id,
                          child: CachedNetworkImage(
                            imageUrl:
                                "${URL_MEDIA_EVENTO}${eventoFavorite.id}/${eventoFavorite.imgVertical}",
                            placeholder: (context, url) =>
                                LoadingStandardWidget.loadingWidget(),
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill),
                              ),
                            ),
                            height: 78.h,
                          ),
                        ),
                      )
                    : SizedBox(),
                _controllerHomeVideo.value.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 90.h,
                            child: VideoPlayer(_controllerHomeVideo),
                          ),
                          Container(
                              height: 50.h,
                              margin: EdgeInsets.symmetric(
                                  vertical: 50.sp, horizontal: 15.sp),
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (prefs.usuarioID != "")
                                        ? "${prefs.nombre} ¡bienvenido!"
                                        : '¡Bienvenido!',
                                    style: TxtStyle.headerStyle.copyWith(
                                        color: Colors.white, fontSize: 11.f),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Somos una iglesia que busca hacer de cada persona un siervo líder, fiel, capaz y comprometido con Dios, que adquiera y reproduzca el carácter de Jesús en otras personas",
                                    style: TxtStyle.descriptionStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  CustomButton(
                                    text: "¡Escucha la radio en vivo!",
                                    loading: false,
                                    color: Colors.white,
                                    margin: EdgeInsets.all(0),
                                    onTap: () {
                                      ref
                                          .read(currentIndexPage.notifier)
                                          .update((state) => 3);
                                    },
                                  )
                                ],
                              )),
                        ],
                      )
                    : SkeletonHome(),
                listEventos.length != 0
                    ? Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: -3,
                                  offset: Offset(0, -1))
                            ],
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.all(20),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Column(
                          children: [
                            Text(
                              "Próximos Eventos",
                              style: TxtStyle.headerStyle
                                  .copyWith(color: ColorStyle.primaryColor),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 25.h,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: listEventos.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return (listEventos[index].isPublic == 1)
                                      ? FadedScaleAnimation(
                                          child: InkWell(
                                            onTap: () => context.pushNamed(
                                                'event',
                                                pathParameters: {
                                                  "eventoID": listEventos[index]
                                                      .id
                                                      .toString()
                                                }),
                                            child: Container(
                                                width: 60.w,
                                                margin: EdgeInsets.only(
                                                    right: 20,
                                                    bottom: 50,
                                                    top: 10),
                                                padding: EdgeInsets.all(11),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        spreadRadius: -12,
                                                        offset: Offset(0, 0))
                                                  ],
                                                ),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  clipBehavior: Clip.none,
                                                  fit: StackFit.expand,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${URL_MEDIA_EVENTO}${listEventos[index].id}/${listEventos[index].imgHorizontal}",
                                                        placeholder: (context,
                                                                url) =>
                                                            LoadingStandardWidget
                                                                .loadingWidget(),
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 20.sp,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fill),
                                                          ),
                                                        ),
                                                        height: 20.sp,
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: -30,
                                                        child: Container(
                                                          height: 5.h,
                                                          width: 40.w,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  blurRadius: 9,
                                                                  spreadRadius:
                                                                      -2,
                                                                  offset:
                                                                      Offset(
                                                                          0, 0))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: ColorStyle
                                                                .secondaryColor,
                                                          ),
                                                          child: Text(
                                                            listEventos[index]
                                                                .nombre,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TxtStyle
                                                                .labelText
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        5.f),
                                                          ),
                                                        )),
                                                    Positioned(
                                                        top: -10,
                                                        right: -10,
                                                        child: Container(
                                                          height: 14.sp,
                                                          width: 19.sp,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5),
                                                                  blurRadius: 9,
                                                                  spreadRadius:
                                                                      -2,
                                                                  offset:
                                                                      Offset(
                                                                          0, 0))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            color: ColorStyle
                                                                .secondaryColor,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                DateFormat('dd')
                                                                    .format(listEventos[
                                                                            index]
                                                                        .fechaInicio)
                                                                    .toUpperCase(),
                                                                style: TxtStyle
                                                                    .labelText
                                                                    .copyWith(
                                                                        fontSize:
                                                                            5.f,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                              Text(
                                                                DateFormat(
                                                                        'MMM')
                                                                    .format(listEventos[
                                                                            index]
                                                                        .fechaInicio)
                                                                    .toUpperCase(),
                                                                style: TxtStyle
                                                                    .labelText
                                                                    .copyWith(
                                                                        fontSize:
                                                                            4.f,
                                                                        color: Colors
                                                                            .white),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )),
                                          ),
                                        )
                                      : SizedBox();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: -3,
                            offset: Offset(0, -1))
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "HORARIOS",
                        style: TxtStyle.headerStyle
                            .copyWith(color: ColorStyle.primaryColor),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Servicios generales",
                        style: TxtStyle.labelText.copyWith(fontSize: 9.f),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Domingos",
                            style: TxtStyle.labelText,
                          ),
                          Row(
                            children: [
                              Text(" - 9:00 AM"),
                              Text(" y 11:30 AM"),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Miércoles",
                            style: TxtStyle.labelText,
                          ),
                          Text(" - 07:00 PM"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Jóvenes",
                        style: TxtStyle.labelText.copyWith(fontSize: 9.f),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Viernes",
                            style: TxtStyle.labelText,
                          ),
                          Text(" - 06:30 PM"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Noches de Restauración",
                        style: TxtStyle.labelText.copyWith(fontSize: 9.f),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sábados",
                            style: TxtStyle.labelText,
                          ),
                          Text(" - 08:30 PM"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CarouselWidget(
                          controller: _controllerC,
                          current: _current,
                          size: 75.sp,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                          image: "assets/image/home/iglesia.png",
                          mainColor: ColorStyle.primaryColor),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Bounceable(
                            onTap: () => NotificationUI.instance
                                .notificationSuccess(
                                    "¡Ya recibirás las alertas de los eventos y demás!"),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 1.5,
                                      color: ColorStyle.primaryColor)),
                              child: Row(
                                children: [
                                  Icon(Icons.notifications),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Recordarme")
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 20, bottom: 50, left: 15, right: 15),
                  child: Column(
                    children: [
                      Text(
                        "VISITANOS",
                        style: TxtStyle.headerStyle
                            .copyWith(color: ColorStyle.primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Puerto de Coatzacoalcos #95Col. Tinijaro Morelia, Michoacán CP. 58337",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      InkWell(
                        onTap: () {
                          //https://www.google.com/maps/place/Amor+y+Restauración+Morelia/@19.6981592,-101.2609889,17z/data=!4m6!3m5!1s0x842d09518248bf2d:0xcb807614fc0e69f1!8m2!3d19.698084!4d-101.258508!16s%2Fg%2F1pty9q8v7?hl=es-ES&entry=tts&shorturl=1
                          final Uri toLaunch = Uri(
                              scheme: 'https',
                              host: 'www.google.com',
                              path:
                                  'maps/place/Amor+y+Restauración+Morelia/@19.6981592,-101.2609889,17z/data=!4m6!3m5!1s0x842d09518248bf2d:0xcb807614fc0e69f1!8m2!3d19.698084!4d-101.258508!16s%2Fg%2F1pty9q8v7',
                              queryParameters: {
                                "hl": "es-ES",
                                "entry": "tts",
                                "shorturl": "1"
                              });

                          launchUrl(toLaunch,
                              mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                          decoration: BoxDecoration(
                              color: ColorStyle.primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Abrir mapa",
                            style: TxtStyle.labelText
                                .copyWith(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshHome(WidgetRef ref) async {
    ref.refresh(liveProvider);
    ref.refresh(getEventosProvider("user"));
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
