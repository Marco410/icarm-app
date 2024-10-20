// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/providers/auth_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/screens/screens.dart';

import '../../providers/notification_provider.dart';
import '../../providers/providers.dart';

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
    ref.watch(newNotiSearchProvider);
    final listNotis = ref.watch(listNotificationsProvider);
    final prefs = PreferenciasUsuario();

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              (prefs.usuarioID != "")
                  ? UserImageProfileWidget(
                      goToPerfil: true,
                      fotoPerfil:
                          (prefs.foto_perfil != "") ? prefs.foto_perfil : null,
                    )
                  : NoLoginWidget(),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () => context.pushNamed('perfil.detail'),
                child: Column(
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
              ),
              SizedBox(
                height: 20,
              ),
              (prefs.pass_update == "1" && prefs.usuarioID != "")
                  ? CustomButton(
                      margin: EdgeInsets.all(0),
                      text: "Da clic aquí para cambiar tu contraseña.",
                      onTap: () => context.pushNamed('change.password'),
                      textColor: Colors.white,
                      color: Colors.blue,
                      loading: false)
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              MenuItemWidget(
                icon: 'noti.svg',
                title: 'NOTIFICACIONES',
                subtitle: 'Consulta tus notificaciones.',
                onTap: () => context.pushNamed('notifications'),
                showDot:
                    (listNotis.isNotEmpty && listNotis.any((n) => n.seen == 0)),
              ),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioID != "")
                  ? MenuItemWidget(
                      icon: 'kids.svg',
                      title: 'A&R KIDS',
                      subtitle: 'Registra a tus hijos en nuestras clases.',
                      onTap: () {
                        context.pushNamed('kids');
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioRol.contains('1') || prefs.usuarioRol.contains('5'))
                  ? MenuItemWidget(
                      icon: 'books.svg',
                      title: 'PASE LISTA',
                      subtitle: 'Pasa la lista a los alumnos',
                      onTap: () {
                        context.pushNamed('pase.lista');
                      },
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioRol.contains('1') ||
                      prefs.usuarioRol.contains('7') ||
                      prefs.usuarioRol.contains('6'))
                  ? MenuItemWidget(
                      icon: 'noti.svg',
                      title: 'NOTIFICAR A VIDEO',
                      subtitle: 'Envia un mensaje a video para los autos',
                      onTap: () => NotificationService.showDialogNotification(
                          null, USER_ICARM_VIDEO, context, ref, null),
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioRol.contains('1'))
                  ? MenuItemWidget(
                      icon: 'user.svg',
                      title: 'ADMINISTRACIÓN',
                      subtitle: 'Administre los eventos de su iglesia',
                      onTap: () => context.pushNamed("admin"),
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioID != "")
                  ? CustomButton(
                      text: "Cerrar Sesión",
                      margin: EdgeInsets.only(top: 10, right: 30, left: 30),
                      onTap: () {
                        NotificationUI.instance.notificationToAcceptAction(
                            context,
                            "Tu sesión se cerrará. \n\n Tendrás que volver a agregar tu usuario y contraseña.",
                            () {
                          ref.refresh(logoutProvider(context));
                        }, false);
                      },
                      loading: false,
                      color: Colors.white,
                      textColor: Colors.black,
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              (prefs.usuarioID != "")
                  ? InkWell(
                      onTap: () {
                        NotificationUI.instance.notificationToAcceptAction(
                            context,
                            "¿Estás seguro de eliminar tu cuenta? Se perderán todos tus datos.",
                            () {
                          ref.refresh(deleteAccountProvider(context));
                        }, false);
                      },
                      child: Text(
                        "Eliminar mi cuenta",
                        style: TxtStyle.labelText
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 60,
              )
            ],
          ),
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
  final bool showDot;
  const MenuItemWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      this.showDot = false,
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
            Expanded(
                flex: 2,
                child: SvgPicture.asset("assets/icon/${icon}", height: 40)),
            Expanded(
              flex: 6,
              child: Column(
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
              ),
            ),
            (showDot)
                ? Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.redAccent,
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
