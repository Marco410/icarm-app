// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/routes/app_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/models/auth/authModels.dart';
import 'package:icarm/presentation/providers/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool loading = false;

  unFocusNodes() {
    passFocus.unfocus();
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
                  "¡Bienvenidos!",
                  style: TxtStyle.headerStyle,
                ),
                SizedBox(
                  height: 15,
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
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      border: true,
                      isRequired: true,
                      textInputType: TextInputType.text,
                      isVisible: false,
                      hintText: 'Contraseña',
                      controller: passController,
                      focusNode: passFocus,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => context.pushNamed("forgot"),
                      child: Text(
                        "¿Olvidaste tu contraseña?",
                        style: TxtStyle.labelText,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Column(
                  children: [
                    CustomButton(
                      text: "Ingresar",
                      onTap: () {
                        if (!_formKey.currentState!.validate()) {
                          NotificationUI.instance.notificationWarning(
                              "Revisa los datos que ingresaste.");
                          return;
                        }

                        setState(() => loading = true);
                        ref.refresh(loginProvider(LoginData(
                          context: context,
                          email: emailController.text,
                          password: passController.text,
                        )));

                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() => loading = false);
                        });
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
