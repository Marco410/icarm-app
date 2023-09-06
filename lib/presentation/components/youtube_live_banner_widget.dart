import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:icarm/presentation/models/YoutubeModel.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeLiveBannerWidget extends StatelessWidget {
  const YoutubeLiveBannerWidget({
    super.key,
    required this.lives,
  });

  final List<Item> lives;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final Uri toLaunch = Uri(
            scheme: 'https',
            host: 'www.youtube.com',
            path: 'watch',
            queryParameters: {"v": "${lives[0].id.videoId}"});

        launchUrl(toLaunch, mode: LaunchMode.externalApplication);
      },
      child: FadedSlideAnimation(
        beginOffset: Offset(0, -1),
        endOffset: Offset(0, 0),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.red,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¡Estamos en vivo! - ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Ver ahora, presiona aquí",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
