import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:lottie/lottie.dart';

import 'package:icarm/config/setting/style.dart';

import '../../components/zcomponents.dart';

class RadioPage extends ConsumerStatefulWidget {
  const RadioPage({
    Key? key,
  }) : super(key: key);
  @override
  ConsumerState<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends ConsumerState<RadioPage> {
  bool loading = false;
  final CarouselController _controllerC = CarouselController();
  int _current = 0;

  List<Widget> textItems = [
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
    Future.microtask(() {
      final radioProvider = ref.watch(radioServiceProvider);
      radioProvider.onPlayerStateChanged.listen((event) {
        ref
            .read(radioisPlayingProvider.notifier)
            .update((state) => event == PlayerState.playing);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(radioServiceProvider);
    final radioIsPlaying = ref.watch(radioisPlayingProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () async {
          if (radioIsPlaying) {
            ref.read(radioisPlayingProvider.notifier).update((state) => false);
            await ref.refresh(radioServiceProvider).stop();
          } else {
            ref.read(radioisPlayingProvider.notifier).update((state) => true);
            final url = "https://stream.zeno.fm/5dsk2i7levzvv";
            await ref.refresh(radioServiceProvider).play(UrlSource(url));
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
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
          child: Icon(
            radioIsPlaying ? Icons.pause : Icons.play_arrow,
            size: 90,
            color: ColorStyle.primaryColor,
          ),
        ),
      ),
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text(
                "A&R Radio - En vivo",
                style: TxtStyle.headerStyle
                    .copyWith(color: ColorStyle.primaryColor, fontSize: 30),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                flex: 8,
                child: CarouselWidget(
                    textItems: textItems,
                    controller: _controllerC,
                    current: _current,
                    size: 0.28,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    image: "assets/image/home/iglesia.png",
                    mainColor: ColorStyle.primaryColor),
              ),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FadedScaleAnimation(
                          child: Text("Radio ICARM",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                        ),
                        FadedScaleAnimation(
                          child: Text("Una palabra, puede cambiar tu vida.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal)),
                        ),
                        Text(
                          'Puede tardar algunos segundos en empezar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        (radioIsPlaying)
                            ? Lottie.network(
                                "https://assets7.lottiefiles.com/packages/lf20_eN8m772nQj.json",
                                height: 60)
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
                                    'Da clic en el botón de play para reproducir nuestra radio.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
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
              Expanded(flex: 5, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
