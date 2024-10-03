import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/api.dart';

import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/controllers/settings_controller.dart';
import 'package:icarm/presentation/providers/providers.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/drawer.dart';
import '../../components/loading_widget.dart';
import '../../providers/home_provider.dart';

class MainHome extends ConsumerStatefulWidget {
  MainHome();

  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends ConsumerState<MainHome> {
  _MainHomeState();
  int currentIndex = 0;

  @override
  void initState() {
    catchVersion();

    super.initState();
  }

  void catchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    print("appVersion");
    print(packageInfo.version);

    final Map<String, dynamic>? version = await SettingsController.getVersion();

    if (version != null && version["value"] != packageInfo.version) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              icon: Icon(
                Icons.update_rounded,
                color: ColorStyle.secondaryColor,
                size: 20.f,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                "¡Nueva actualización disponible! 🎉",
                style: TxtStyle.headerStyle,
              ),
              content: Text(
                  "${version["data"]}\nActualiza ahora para obtener las nuevas características que añadimos.",
                  style: TextStyle(fontSize: 6.5.f)),
              backgroundColor: Colors.white,
              actions: <Widget>[
                Bounceable(
                  onTap: () => ctx.pop(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "En otro momento",
                      style: TextStyle(
                        color: ColorStyle.hintDarkColor,
                        fontSize: 6.f,
                      ),
                    ),
                  ),
                ),
                Bounceable(
                  onTap: () {
                    final Uri _url =
                        Uri.parse('https://${BASE_URL}/public/icarm-app');
                    launchUrl(_url, mode: LaunchMode.externalApplication);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    decoration: BoxDecoration(
                        color: ColorStyle.secondaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Actualizar ahora",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.4.f,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            );
          },
          barrierDismissible: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(liveProvider);
    final bodyAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(),
      drawer: const MaterialDrawer(),
      body: ConnectivityWidgetWrapper(
        alignment: Alignment.topLeft,
        color: Colors.blueGrey,
        message: "Se perdio la conexión a internet",
        stacked: true,
        child: bodyAsync.when(
            data: (widgetBody) => widgetBody,
            error: (_, __) =>
                Center(child: LoadingStandardWidget.loadingErrorWidget()),
            loading: () => Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: LoadingStandardWidget.loadingWidget(),
                )),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorStyle.primaryColor,
        color: ColorStyle.primaryColor,
        buttonBackgroundColor: ColorStyle.secondaryColor,
        animationDuration: Duration(milliseconds: 100),
        animationCurve: Curves.easeOut,
        index: 2,
        items: <Widget>[
          Icon(
            Icons.podcasts_rounded,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.map_outlined,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.home_filled,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.radio_rounded,
            size: 26,
            color: Colors.white,
          ),
          Icon(
            Icons.info_rounded,
            size: 26,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          ref.read(currentIndexPage.notifier).update((state) => index);
        },
      ),
    );
  }
}
