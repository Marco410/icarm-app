import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:icarm/config/setting/style.dart';

import '../../providers/radio_service.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({
    Key? key,
  }) : super(key: key);
  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  bool loading = true;

  void initState() {
    final radioService = Provider.of<RadioService>(context, listen: false);

    radioService.audioPlayerGet.onPlayerStateChanged.listen((event) {
      setState(() {
        radioService.isPlayingSet = event == PlayerState.playing;
      });
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
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
    final radioService = Provider.of<RadioService>(context);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: InkWell(
        onTap: () async {
          if (radioService.isPlayingGet) {
            await radioService.audioPlayerGet.stop();
          } else {
            final url = "https://stream.zeno.fm/5dsk2i7levzvv";
            await radioService.audioPlayerGet.play(UrlSource(url));
          }
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: ColorStyle.secondaryColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 11,
                    spreadRadius: 1,
                    offset: Offset(0, 0))
              ],
              borderRadius: BorderRadius.circular(100)),
          child: Icon(
            radioService.isPlayingGet ? Icons.pause : Icons.play_arrow,
            size: 90,
            color: ColorStyle.whiteBacground,
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
              Expanded(
                flex: 8,
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.4,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 0))
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.asset(
                      "assets/image/logo.png",
                      scale: 0.3,
                    )),
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
                        (radioService.isPlayingGet)
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
