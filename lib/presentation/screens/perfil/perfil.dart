// ignore_for_file: must_be_immutable, unused_result

import 'dart:async';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/components/carousel_widget.dart';
import 'package:icarm/presentation/components/components.dart';
import 'package:icarm/presentation/components/content_ad_widget.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/video_home_widget.dart';
import 'package:icarm/presentation/providers/auth_service.dart';
import 'package:icarm/presentation/providers/youtube_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:icarm/config/setting/style.dart';

class PerfilPage extends ConsumerStatefulWidget {
  PerfilPage();

  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends ConsumerState<PerfilPage> {
  _PerfilPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    ref.watch(liveProvider);
    final prefs = PreferenciasUsuario();

    final mediaHeight = MediaQuery.of(context).size.height;
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/icon/user-icon.svg", height: 100),
            SizedBox(
              height: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${prefs.nombre}',
                  style: TxtStyle.headerStyle,
                ),
                Text(
                  "${prefs.aPaterno} ${prefs.aMaterno}",
                  style: TxtStyle.headerStyle,
                )
              ],
            ),
            MenuItemWidget(
              icon: 'noti.svg',
              title: 'NOTIFICACIONES',
              subtitle: 'Configura las notificaciones que recibirás.',
              onTap: () {},
            ),
            MenuItemWidget(
              icon: 'kids.svg',
              title: 'A&R KIDS',
              subtitle: 'Registra a tus hijos en nuestras clases.',
              onTap: () {
                context.pushNamed('kids');
              },
            ),
            CustomButton(
              text: "Cerrar Sesión",
              onTap: () {
                ref.refresh(logoutProvider(context));
              },
              loading: false,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Function onTap;
  const MenuItemWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function(),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: ColorStyle.hintDarkColor, width: 0.2),
        )),
        child: Row(
          children: [
            SvgPicture.asset("assets/icon/${icon}", height: 40),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TxtStyle.labelText.copyWith(fontSize: 16),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitle,
                  style: TxtStyle.hintText,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
