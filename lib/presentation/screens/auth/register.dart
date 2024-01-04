// ignore_for_file: unused_result

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/app_bar_auth_widget.dart';
import 'package:icarm/presentation/components/custombutton.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/components/dropdown_widget.dart';
import 'package:icarm/presentation/components/find_register_users.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/providers/auth_service.dart';
import 'package:intl/intl.dart';

import '../../models/models.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  FocusNode focusTelefono = FocusNode();
  FocusNode nombreFocus = FocusNode();
  FocusNode aPaternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool isVisible = false;
  bool loading = false;
  Option sexo = Option(id: 0, name: "Seleccione");
  List<Option> sexoList = [
    Option(id: 1, name: "Hombre"),
    Option(id: 2, name: "Mujer")
  ];

  Option pais = Option(id: 0, name: "Seleccione");
  List<Option> paisList = [
    Option(id: 1, name: "México"),
    Option(id: 2, name: "Estados Unidos"),
    Option(id: 3, name: "Otro"),
  ];
  int? user_id;

  @override
  Widget build(BuildContext context) {
    List<User> findUsersList = ref.watch(findUsersRegisterList);

    return GestureDetector(
      onTap: unFocusFields,
      child: Scaffold(
        appBar: AppBarAuthWidget(
          backButton: true,
        ),
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    label: "Nombre",
                    hintText: 'Escribe aquí',
                    controller: nombreController,
                    focusNode: nombreFocus,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    label: "Apellido Paterno",
                    hintText: 'Escribe aquí',
                    controller: aPaternoController,
                    onEditingComplete: findUserRegister,
                    focusNode: aPaternoFocus,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: false,
                    textInputType: TextInputType.text,
                    label: "Apellido Materno",
                    hintText: 'Escribe aquí',
                    controller: aMaternoController,
                    onEditingComplete: findUserRegister,
                    focusNode: aMaternoFocus,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  (findUsersList.length != 0)
                      ? GestureDetector(
                          onTap: () => selectUserFinded(),
                          child: FadedScaleAnimation(
                            child: Text(
                              "Puede que ya tengamos tu registro. Da clic aquí para obtenerlo.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.emailAddress,
                    label: "Correo Electrónico",
                    hintText: 'Escribe aquí',
                    controller: emailController,
                    onTap: findUserRegister,
                    focusNode: emailFocus,
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
                    suffixIcon: IconButton(
                      icon: Icon(
                        (isVisible) ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black87,
                      ),
                      onPressed: () => setState(() {
                        isVisible = !isVisible;
                      }),
                    ),
                    controller: passConfirmController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    label: 'Fecha de nacimiento',
                    border: true,
                    labelColor: Colors.black,
                    hintText: "aaaa-mm-dd",
                    color: Colors.white,
                    controller: nacimientoController,
                    onTap: () => selectDate(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.calendar_month_rounded,
                        color: ColorStyle.secondaryColor,
                      ),
                      onPressed: () => selectDate(),
                    ),
                    readOnly: true,
                    textInputType: TextInputType.datetime,
                    isRequired: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: false,
                    textInputType: TextInputType.number,
                    label: "Teléfono",
                    hintText: 'Escribe aquí',
                    focusNode: focusTelefono,
                    controller: telefonoController,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownWidget(
                      title: "Sexo",
                      option: sexo,
                      isRequired: false,
                      onTapFunction: () async {
                        final res = await showDropdownOptions(context,
                            MediaQuery.of(context).size.height * 0.4, sexoList);

                        if (res != null) {
                          setState(() {
                            sexo = res[0] as Option;
                          });
                        }
                      }),
                  SizedBox(
                    height: 5,
                  ),
                  DropdownWidget(
                      title: "País",
                      option: pais,
                      isRequired: false,
                      onTapFunction: () async {
                        final res = await showDropdownOptions(context,
                            MediaQuery.of(context).size.height * 0.4, paisList);

                        if (res != null) {
                          setState(() {
                            pais = res[0] as Option;
                          });
                        }
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      CustomButton(
                        text: "Registrarme",
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            NotificationUI.instance.notificationWarning(
                                "Revisa los datos que ingresaste.");
                            return;
                          }

                          if (passController.text !=
                              passConfirmController.text) {
                            NotificationUI.instance.notificationWarning(
                                "Las contraseñas no coinciden");
                            return;
                          }

                          setState(() => loading = true);
                          ref.refresh(registerProvider(RegisterUserData(
                              context: context,
                              nombre: nombreController.text,
                              a_paterno: aPaternoController.text,
                              a_materno: aMaternoController.text,
                              email: emailController.text,
                              password: passController.text,
                              telefono: telefonoController.text,
                              sexo: sexo.name,
                              pais_id: pais.id,
                              user_id: user_id,
                              fecha_nacimiento: nacimientoController.text)));

                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() => loading = false);
                          });
                        },
                        loading: loading,
                        textColor: Colors.white,
                        margin: EdgeInsets.all(0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  findUserRegister() async {
    ref.refresh(findUserRegisterProvider(RegisterUserData(
        nombre: nombreController.text,
        a_paterno: aPaternoController.text,
        a_materno: aMaternoController.text,
        context: context)));
    List<User> findUsersList = ref.watch(findUsersRegisterList);
    if (findUsersList.length != 0) {
      selectUserFinded();
    }
  }

  selectUserFinded() async {
    List<User> findUsersList = ref.watch(findUsersRegisterList);

    final res = await showUsersRegister(context, findUsersList);

    if (res != null) {
      final userFinded = res[0] as User;

      print(userFinded.email);
      if (userFinded.email.isNotEmpty) {
        NotificationUI.instance.notificationWarning(
            "${userFinded.nombre} ya tenemos tu registro, intenta iniciar sesión con tu correo y contraseña.");
        return;
      }

      setState(() {
        if (userFinded.nombre.indexOf(" ").isNaN) {
          nombreController.text =
              "${userFinded.nombre[0].toUpperCase()}${userFinded.nombre.substring(1, userFinded.nombre.indexOf(" ")).toLowerCase()} ${userFinded.nombre[userFinded.nombre.indexOf(" ") + 1].toUpperCase()}${userFinded.nombre.substring(userFinded.nombre.indexOf(" ") + 2).toLowerCase()}";
        } else {
          nombreController.text =
              "${userFinded.nombre[0].toUpperCase()}${userFinded.nombre.substring(1).toLowerCase()}";
        }

        aPaternoController.text =
            "${userFinded.apellidoPaterno[0].toUpperCase()}${userFinded.apellidoPaterno.substring(1).toLowerCase()}";
        aMaternoController.text =
            "${userFinded.apellidoMaterno[0].toUpperCase()}${userFinded.apellidoMaterno.substring(1).toLowerCase()}";
        telefonoController.text = userFinded.telefono;
        nacimientoController.text = userFinded.fechaNacimiento;
        user_id = userFinded.id;
      });
    }
  }

  unFocusFields() {
    focusTelefono.unfocus();
    nombreFocus.unfocus();
    aPaternoFocus.unfocus();
    aMaternoFocus.unfocus();
    emailFocus.unfocus();
  }

  selectDate() async {
    DateTime? pickedDate = await showDatePicker(
        locale: const Locale('es', 'MX'),
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year.toInt() - 105),
        lastDate: DateTime(DateTime.now().year.toInt() + 1),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: ColorStyle.secondaryColor,
                onPrimary: ColorStyle.whiteBacground,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black54,
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            child: child!,
          );
        });

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

      setState(() {
        nacimientoController.text = formattedDate;
      });
    }
  }
}
