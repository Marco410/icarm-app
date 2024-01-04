import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/providers/providers.dart';

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
  Widget build(BuildContext context) {
    ref.watch(liveProvider);
    final bodyAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(),
      drawer: const MaterialDrawer(),
      body: bodyAsync.when(
          data: (widgetBody) => widgetBody,
          error: (_, __) =>
              Center(child: LoadingStandardWidget.loadingErrorWidget()),
          loading: () => Container(
                margin: const EdgeInsets.only(top: 50),
                child: LoadingStandardWidget.loadingWidget(),
              )),
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
            Icons.settings_outlined,
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
