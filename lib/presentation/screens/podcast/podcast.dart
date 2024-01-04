import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "${prefs.nombre} escuchanos:",
                  style: TxtStyle.headerStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Lottie.network(
                    "https://assets7.lottiefiles.com/packages/lf20_eN8m772nQj.json",
                    height: 10),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 10,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 4,
                            spreadRadius: -3,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: Html(
                    data: '''
                   <iframe src="https://www.amoryrestauracionmorelia.org/podcast-1" width="auto" height="${MediaQuery.of(context).size.height * 0.50}"  ></iframe>
                  ''',
                    extensions: [
                      IframeHtmlExtension(),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PodcastLinkWidget(
                        title: "Spotify",
                        logo: 'spotify.png',
                        host: 'open.spotify.com',
                        path: "show/4L6AqbIfxp4FA1VEYYRCIy",
                        queryParameters: {},
                      ),
                      PodcastLinkWidget(
                        title: "Amazon Music",
                        logo: 'amazon_music.png',
                        host: 'music.amazon.es',
                        path:
                            "podcasts/db972f87-5c01-43fd-9a33-f93abcab3af5/amor-restauraci%C3%B3n-morelia",
                        queryParameters: {},
                      ),
                      PodcastLinkWidget(
                        title: "Apple Podcast",
                        logo: 'apple_podcasts.png',
                        host: 'podcasts.apple.com',
                        path:
                            "mx/podcast/amor-restauraci%C3%B3n-morelia/id1540637772",
                        queryParameters: {},
                      ),
                      PodcastLinkWidget(
                        title: "Castbox",
                        logo: 'cast.png',
                        host: 'castbox.fm',
                        path: "channel/id3526755",
                        queryParameters: {
                          "utm_source": "website",
                          "utm_medium": "dlink",
                          "utm_campaign": "web_share",
                          "utm_content":
                              "Predicas%20Amor%20%26%20Restauraci%C3%B3n%20Morelia-CastBox_FM",
                        },
                      ),
                      //https://www.google.com/podcasts?feed=
                      PodcastLinkWidget(
                        title: "Google Podcast",
                        logo: 'google_podcasts.png',
                        host: 'www.google.com',
                        path: "podcasts",
                        queryParameters: {
                          "feed":
                              "aHR0cHM6Ly9hbmNob3IuZm0vcy8zZmNkYzc0NC9wb2RjYXN0L3Jzcw=="
                        },
                      ),
                      //https://radiopublic.com/predicas-amor-restauracin-moreli-6N2A0A
                      PodcastLinkWidget(
                        title: "RadioPublic",
                        logo: 'radiopublic.png',
                        host: 'radiopublic.com',
                        path: "predicas-amor-restauracin-moreli-6N2A0A",
                        queryParameters: {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PodcastLinkWidget extends StatelessWidget {
  final String title;
  final String logo;
  final String host;
  final String path;
  final Map<String, dynamic> queryParameters;
  const PodcastLinkWidget(
      {super.key,
      required this.title,
      required this.logo,
      required this.path,
      required this.host,
      required this.queryParameters});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final Uri toLaunch = Uri(
            scheme: 'https',
            host: host,
            path: path,
            queryParameters: queryParameters);

        launchUrl(toLaunch, mode: LaunchMode.externalApplication);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: -3,
                offset: Offset(0, 0))
          ],
        ),
        child: Image.asset(
          "assets/logos/${logo}",
          scale: 1.5,
        ),
      ),
    );
  }
}
