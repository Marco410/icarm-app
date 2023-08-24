import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PodcastPage extends StatefulWidget {
  const PodcastPage({
    Key? key,
  }) : super(key: key);
  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  bool loading = true;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FadedSlideAnimation(
          beginOffset: Offset(0, 0.3),
          endOffset: Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            margin: EdgeInsets.only(bottom: 50),
            child: Html(
              data: '''
              <iframe allow="autoplay *; encrypted-media *; fullscreen *; clipboard-write" style="border-radius:100px" src="https://embed.podcasts.apple.com/mx/podcast/amor-restauraci%C3%B3n-morelia/id1540637772" width="100%" height="${MediaQuery.of(context).size.height * 0.70}"  allow="autoplay; clipboard-write; encrypted-media;" loading="lazy"  ></iframe>
            ''',
              style: {"footer": Style(display: Display.none)},
            ),
          ),
        ),
      ),
    );
  }
}
