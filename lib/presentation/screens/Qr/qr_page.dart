// ignore_for_file: must_be_immutable, unused_result

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPage extends ConsumerStatefulWidget {
  QRPage();

  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends ConsumerState<QRPage> {
  _QRPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    Random random = new Random();
    final qrData = "AYR${random.nextInt(80) + 10}${prefs.usuarioID}";
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (prefs.usuarioID != "")
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250,
                      backgroundColor: Colors.white,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                          color: Colors.black, size: Size(60, 40)),
                      constrainErrorBounds: true,
                      // ignore: deprecated_member_use
                      foregroundColor: ColorStyle.primaryColor,
                      padding: EdgeInsets.all(20),
                    ),
                  )
                : NoLoginWidget(),
            (prefs.usuarioID != "")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${prefs.nombre}',
                        style: TxtStyle.headerStyle,
                      ),
                      Text(
                        "${prefs.aPaterno} ${prefs.aMaterno}",
                        style: TxtStyle.headerStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        qrData,
                        style: TxtStyle.hintText,
                      )
                    ],
                  )
                : SizedBox(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: ColorStyle.hintColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(children: [
                Text(
                  "Beneficios de tu código",
                  style: TxtStyle.headerStyle.copyWith(fontSize: 16),
                ),
                SizedBox(
                  height: 15,
                ),
                BeneficiosQrWidget(
                  text: "Acceso rápido en retiros y eventos",
                ),
                BeneficiosQrWidget(
                  text: "Ficha para recoger a tus hijos",
                ),
                BeneficiosQrWidget(
                  text: "Descuentos en librería",
                ),
                BeneficiosQrWidget(
                  text: "Y mucho más",
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

class NoLoginWidget extends StatelessWidget {
  final showOnlyButton;
  final textToShow;
  const NoLoginWidget(
      {super.key,
      this.showOnlyButton = false,
      this.textToShow = "Iniciar sesión"});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (!showOnlyButton)
            ? SizedBox(
                height: 20,
              )
            : SizedBox(),
        (!showOnlyButton)
            ? SvgPicture.asset("assets/icon/user-icon.svg", height: 100)
            : SizedBox(),
        (!showOnlyButton)
            ? SizedBox(
                height: 15,
              )
            : SizedBox(),
        CustomButton(
            text: "${textToShow}",
            onTap: () => context.goNamed('login'),
            textColor: Colors.white,
            color: ColorStyle.primaryColor,
            margin: (!showOnlyButton)
                ? EdgeInsets.symmetric(vertical: 40, horizontal: 30)
                : EdgeInsets.all(0),
            loading: false),
        (!showOnlyButton)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("¿No tienes una cuenta?"),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () => context.pushNamed('register'),
                        child: Text(
                          "Regístrate",
                          style: TxtStyle.labelText,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : SizedBox(),
      ],
    );
  }
}

class BeneficiosQrWidget extends StatelessWidget {
  final String text;
  const BeneficiosQrWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.check_rounded,
        ),
        SizedBox(
          width: 10,
        ),
        Text(text)
      ],
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
