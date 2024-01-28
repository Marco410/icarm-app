import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/setting/style.dart';
import '../../components/zcomponents.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: (loading)
          ? LoadingStandardWidget.loadingWidget()
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Html(
                data: '''
                     <iframe src="${widget.url}" width="auto" height="${MediaQuery.of(context).size.height * 0.85}" allowfullscreen  frameborder="0" style="border:0-moz-border-radius: 15px;
border-radius: 15px;" ></iframe>
                    ''',
                onLinkTap: (url, attributes, element) => (url != null)
                    // ignore: deprecated_member_use
                    ? launch(url)
                    : NotificationUI.instance
                        .notificationWarning("No podemos abrir este link."),
                extensions: [
                  IframeHtmlExtension(),
                ],
              ),
            ),
    );
  }
}
