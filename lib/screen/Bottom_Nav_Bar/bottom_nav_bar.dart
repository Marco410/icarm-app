import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:icarm/screen/beteles/beteles.dart';
import 'package:icarm/screen/church/church.dart';
import 'package:icarm/screen/home/home.dart';
import 'package:icarm/screen/podcast/podcast.dart';
import 'package:icarm/screen/radio/radio.dart';
import 'package:flutter/material.dart';

import 'package:icarm/setting/style.dart';
import 'package:provider/provider.dart';

import '../../services/load_data_service.dart';
import '../../services/page_service.dart';

class bottomNavBar extends StatefulWidget {
  bottomNavBar();

  _bottomNavBarState createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  _bottomNavBarState();
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return PodcastPage();
      case 1:
        return ChurchPage();
      case 2:
        return home();
      case 3:
        return RadioPage();

      default:
        return BetelesPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadDataService =
        Provider.of<LoadDataService>(context, listen: false);

    final pageService = Provider.of<PageService>(context, listen: false);
    loadDataService.load_data(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /* leading: Container(
            margin: EdgeInsets.all(9),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.face_rounded,
              color: colorStyle.primaryColor,
            ),
          ), */
        title: Text(
          'Amor & Restauración Morelia',
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "Gotik",
              fontWeight: FontWeight.bold,
              fontSize: 18.5),
        ),
        /* actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: GestureDetector(
                  child: Icon(Icons.notifications_rounded,
                      size: 28, color: Colors.white),
                  onTap: () {
                    /* Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) =>
                            setting(themeBloc: _themeBloc))); */
                  },
                ),
              ),
            ),
          ] */
      ),
      body: callPage(pageService.currentPage),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: colorStyle.primaryColor,
        buttonBackgroundColor: colorStyle.primaryColor,
        animationDuration: Duration(milliseconds: 170),
        index: pageService.currentPage,
        items: <Widget>[
          ImageIcon(
            AssetImage('assets/icon/spotify.png'),
            color: Colors.white,
            size: 26,
          ),
          Icon(
            Icons.church_rounded,
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
            Icons.maps_home_work_rounded,
            size: 26,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            pageService.currentPageSet = index;
          });
        },
      ),
    );
  }
}
