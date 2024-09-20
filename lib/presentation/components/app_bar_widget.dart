import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/routes/app_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:sizer_pro/sizer.dart';

import '../../config/share_prefs/prefs_usuario.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool backButton;
  final bool rightButtons;
  const AppBarWidget({
    this.backButton = false,
    this.rightButtons = true,
    super.key,
  });

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  final double _prefferedHeight = 45;

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();

    return AppBar(
      backgroundColor: ColorStyle.whiteBacground,
      elevation: 0,
      leading: (widget.backButton)
          ? InkWell(
              onTap: () => context.pop(),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: ColorStyle.primaryColor,
                size: 26,
              ),
            )
          : InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.menu_rounded,
                color: ColorStyle.primaryColor,
                size: 34,
              ),
            ),
      title: ImageIcon(
        AssetImage("assets/image/logo.png"),
        color: Colors.black,
        size: 20.sp,
      ),
      actions: <Widget>[
        (widget.rightButtons)
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.pushNamed('qr'),
                        child: Icon(
                          Icons.qr_code_rounded,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () {
                            NavigationRoutes.goPerfil(context);
                          },
                          child: (prefs.foto_perfil != "")
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${URL_MEDIA_FOTO_PERFIL}${prefs.foto_perfil}",
                                    placeholder: (context, url) =>
                                        LoadingStandardWidget.loadingWidget(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 12.sp,
                                      height: 13.sp,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                            "assets/icon/user-icon.svg"),
                                    height: 13.sp,
                                  ),
                                )
                              : SvgPicture.asset("assets/icon/user-icon.svg")),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
