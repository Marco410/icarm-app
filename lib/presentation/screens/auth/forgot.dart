// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/routes/app_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/text_field.dart';

import '../../controllers/auth_controller.dart';

class ForgotPage extends ConsumerStatefulWidget {
  const ForgotPage({super.key});

  @override
  ConsumerState<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends ConsumerState<ForgotPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  FocusNode emailFocus = FocusNode();

  bool loading = false;

  unFocusNodes() {
    emailFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unFocusNodes,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/image/logo.png',
                    scale: 60,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Recupera tu contraseña",
                  style: TxtStyle.headerStyle,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Escribe tu correo electronico para que te llegue un correo de recuperación.",
                  style: TxtStyle.labelText,
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFieldWidget(
                      border: true,
                      isRequired: true,
                      textInputType: TextInputType.emailAddress,
                      hintText: 'Correo electrónico',
                      controller: emailController,
                      focusNode: emailFocus,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    CustomButton(
                      text: "Recuperar contraseña",
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) {
                          NotificationUI.instance.notificationWarning(
                              "Revisa los datos que ingresaste.");
                          return;
                        }
                        setState(() => loading = true);

                        bool resp = await AuthController.forgotPass(
                            emailController.text, ref);

                        if (resp) {
                          setState(() => loading = false);
                          context.pop();
                        } else {
                          setState(() => loading = false);
                        }
                      },
                      loading: loading,
                      textColor: Colors.white,
                      margin: EdgeInsets.all(0),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("¿Ya tienes una cuenta?"),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () => context.pop(),
                          child: Text(
                            "Ingresa aquí",
                            style: TxtStyle.labelText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("¿No tienes una cuenta?"),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () => NavigationRoutes.goRegister(context),
                          child: Text(
                            "Regístrate",
                            style: TxtStyle.labelText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
