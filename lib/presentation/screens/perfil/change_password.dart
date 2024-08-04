// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/controllers/auth_controller.dart';

import '../../providers/notification_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  ChangePasswordPage();

  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  _ChangePasswordPageState();
  bool isVisible = false;
  bool loading = false;
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();

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
              SizedBox(
                height: 15,
              ),
              Text(
                "Cambia tu contraseña",
                style: TxtStyle.labelText,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Recuerda actualizar tu contraseña a una que se te haga familiar.",
                textAlign: TextAlign.center,
                style:
                    TxtStyle.labelText.copyWith(fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 15,
              ),
              TextFieldWidget(
                border: true,
                isRequired: true,
                textInputType: TextInputType.text,
                isVisible: isVisible,
                label: "Contraseña",
                hintText: 'Escribe aquí',
                suffixIcon: IconButton(
                  icon: Icon(
                    (isVisible) ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black87,
                  ),
                  onPressed: () => setState(() {
                    isVisible = !isVisible;
                  }),
                ),
                controller: passController,
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                border: true,
                isRequired: true,
                textInputType: TextInputType.text,
                isVisible: isVisible,
                label: "Confirmar contraseña",
                hintText: 'Escribe aquí',
                controller: passConfirmController,
              ),
              CustomButton(
                text: "Guardar nueva contraseña",
                onTap: () async {
                  if (passController.text == "" ||
                      passConfirmController.text == "") {
                    NotificationUI.instance
                        .notificationWarning("Los campos son requeridos.");
                    return;
                  }
                  if (passController.text != passConfirmController.text) {
                    NotificationUI.instance
                        .notificationWarning("Las contraseñas no son iguales.");
                    return;
                  }

                  setState(() => loading = true);

                  bool res = await AuthController.updatePassword(
                      passController.text, ref);

                  if (res) {
                    setState(() => loading = false);
                    prefs.pass_update = "0";
                    context.pop();
                  } else {
                    setState(() => loading = false);
                  }
                },
                loading: loading,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
