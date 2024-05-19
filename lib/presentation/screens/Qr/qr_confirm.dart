// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/dropdown_widget.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/controllers/pase_lista_controller.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:icarm/presentation/screens/perfil/perfil-detail.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';

import '../../components/dropdow_options.dart';
import '../../models/UsuarioModel.dart';
import '../../providers/pase_lista_service.dart';

class QRConfirm extends ConsumerStatefulWidget {
  QRConfirm();

  _QRConfirmState createState() => _QRConfirmState();
}

class _QRConfirmState extends ConsumerState<QRConfirm> {
  _QRConfirmState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final userScanned = ref.watch(userScannedProvider);
    final eventoSelected = ref.watch(eventoSelectedToPaseLista);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        ref.read(userScannedProvider.notifier).update((state) => null);
      },
      child: Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        appBar: AppBarWidget(
          backButton: true,
          rightButtons: false,
        ),
        drawer: const MaterialDrawer(),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.face_rounded,
                  size: 50,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Pase de lista para:",
                  style: TxtStyle.headerStyle
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 15,
                ),
                UserScannedWidget(
                  userScanned: userScanned,
                  ref: ref,
                ),
                (userScanned != null)
                    ? CustomButton(
                        text: "Confirmar",
                        onTap: () {
                          if (eventoSelected.id == 0) {
                            NotificationUI.instance.notificationWarning(
                                'No seleccionaste el evento. Regresa atrás para seleccionarlo.');
                            return;
                          }

                          PaseListaController.addPaseLista(
                                  usuarioID: userScanned.id.toString(),
                                  eventoID: eventoSelected.id.toString())
                              .then((value) {
                            if (value) {
                              NotificationUI.instance.notificationSuccess(
                                  'Pase de lista exitoso.');

                              ref
                                  .read(userScannedProvider.notifier)
                                  .update((state) => null);

                              context.pop();
                            } else {
                              NotificationUI.instance.notificationWarning(
                                  'No pudimos completar la operación, inténtelo más tarde.');
                            }
                          });

                          /*    ref.refresh(addPaseListaProvider(PaseListaData(
                                  context: context,
                                  user_id: userScanned.id.toString()))); */
                        },
                        loading: false,
                        textColor: Colors.white,
                        margin: EdgeInsets.only(top: 40),
                        color: ColorStyle.secondaryColor,
                      )
                    : SizedBox(),
                CustomButton(
                  text: "Cancelar",
                  onTap: () {
                    ref
                        .read(userScannedProvider.notifier)
                        .update((state) => null);

                    context.pushReplacementNamed('scanner',
                        pathParameters: {"type": "pase_lista"});
                  },
                  loading: false,
                  color: ColorStyle.hintDarkColor,
                  textColor: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserScannedWidget extends ConsumerStatefulWidget {
  UserScannedWidget({
    super.key,
    required this.userScanned,
    required this.ref,
  });

  final User? userScanned;
  final WidgetRef ref;

  @override
  ConsumerState<UserScannedWidget> createState() => _UserScannedWidgetState();
}

class _UserScannedWidgetState extends ConsumerState<UserScannedWidget> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController asignacionController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  FocusNode nombreFocus = FocusNode();
  FocusNode aPaternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();
  FocusNode asignacionFocus = FocusNode();
  FocusNode nacimientoFocus = FocusNode();
  FocusNode telefonoFocus = FocusNode();

  Option maestroSelected = Option(id: 0, name: "Seleccione:");

  bool loadingEdit = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final edit = ref.watch(editUserPaseListProvider);
    final maestrosList = ref.watch(maestrosListOptionProvider);

    return (widget.userScanned != null)
        ? GestureDetector(
            onTap: () => focusFields(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '${widget.userScanned!.nombre} ${widget.userScanned!.apellidoPaterno} ${widget.userScanned!.apellidoMaterno}',
                      textAlign: TextAlign.center,
                      style: TxtStyle.headerStyle.copyWith(fontSize: 8.sp),
                    ),
                  ),
                  Text(
                    "AYR01${widget.userScanned?.id ?? "-"}",
                    style: TxtStyle.hintText,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (!edit)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                ShowDataWidget(
                                  title: "Email",
                                  data: widget.userScanned!.email,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShowDataWidget(
                                  title: "Teléfono",
                                  color: (widget.userScanned?.telefono != null)
                                      ? Colors.black
                                      : Colors.red,
                                  data: widget.userScanned?.telefono ?? "",
                                ),
                                ShowDataWidget(
                                  title: "Fecha de nacimiento",
                                  color: (widget.userScanned?.fechaNacimiento !=
                                          null)
                                      ? Colors.black
                                      : Colors.red,
                                  data: widget.userScanned?.fechaNacimiento !=
                                          null
                                      ? DateFormat('dd MMMM yyyy').format(
                                          widget.userScanned?.fechaNacimiento ??
                                              DateTime.now())
                                      : "-",
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ShowDataWidget(
                                  title: (widget.userScanned?.maestroVision !=
                                          null)
                                      ? "Maestro"
                                      : "Actualiza el maestro",
                                  color: (widget.userScanned?.maestroVision !=
                                          null)
                                      ? Colors.black
                                      : Colors.red,
                                  data: (widget.userScanned?.maestroVision ==
                                          null)
                                      ? widget.userScanned?.maestro ?? ""
                                      : widget.userScanned?.maestroVision
                                              ?.maestroUser.nombre ??
                                          "",
                                ),
                                ShowDataWidget(
                                  title: "Ministerios",
                                  color: (widget.userScanned?.asignacion != "")
                                      ? Colors.black
                                      : Colors.red,
                                  data: widget.userScanned?.ministeriosData
                                          .map((e) => e.ministerio.name)
                                          .join(' | ') ??
                                      "-",
                                ),
                              ],
                            ),
                          ],
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
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
                                focusNode: aMaternoFocus,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFieldWidget(
                                border: true,
                                isRequired: true,
                                textInputType: TextInputType.number,
                                label: "Teléfono",
                                hintText: 'Escribe aquí',
                                focusNode: telefonoFocus,
                                controller: telefonoController,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFieldWidget(
                                border: true,
                                isRequired: false,
                                textInputType: TextInputType.text,
                                label: "Asignación",
                                hintText: 'Escribe aquí',
                                controller: asignacionController,
                                focusNode: asignacionFocus,
                              ),
                              DropdownWidget(
                                  title: "Maestro",
                                  option: maestroSelected,
                                  isRequired: true,
                                  readOnly: false,
                                  onTapFunction: () async {
                                    final res = await showDropdownOptions(
                                        context,
                                        MediaQuery.of(context).size.height *
                                            0.4,
                                        maestrosList);

                                    if (res != null) {
                                      setState(() {
                                        maestroSelected = res[0] as Option;
                                      });
                                    }
                                  }),
                              SizedBox(
                                height: 15,
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
                                isRequired: true,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (!edit)
                          ? GestureDetector(
                              onTap: () {
                                if (widget.userScanned != null) {
                                  ref
                                      .read(editUserPaseListProvider.notifier)
                                      .update((state) => !edit);
                                  setData(widget.userScanned!);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 20),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorStyle.secondaryColor),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            )
                          : SizedBox(),
                      (edit)
                          ? GestureDetector(
                              onTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  NotificationUI.instance.notificationWarning(
                                      "Revisa los datos que ingresaste.");
                                  return;
                                }

                                setState(() {
                                  loadingEdit = true;
                                });

                                PaseListaController.updateUserPaseLista(
                                        userID:
                                            widget.userScanned!.id.toString(),
                                        nombre: nombreController.text,
                                        apellido_paterno:
                                            aPaternoController.text,
                                        apellido_materno:
                                            aMaternoController.text,
                                        fecha_nacimiento:
                                            nacimientoController.text,
                                        telefono: telefonoController.text,
                                        maestro_id:
                                            maestroSelected.id.toString(),
                                        asignacion: asignacionController.text)
                                    .then((value) {
                                  if (value) {
                                    ref
                                        .read(editUserPaseListProvider.notifier)
                                        .update((state) => !edit);

                                    ref.refresh(getUserPaseListaProvider(
                                        widget.userScanned!.id.toString()));
                                  }

                                  setState(() {
                                    loadingEdit = false;
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 40),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorStyle.secondaryColor),
                                child: (loadingEdit)
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Icon(
                                        Icons.save_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                              ),
                            )
                          : SizedBox(),
                      GestureDetector(
                        onTap: () {
                          if (edit) {
                            ref
                                .read(editUserPaseListProvider.notifier)
                                .update((state) => !edit);
                          } else {
                            ref
                                .read(userScannedProvider.notifier)
                                .update((state) => null);
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[300]),
                          child: Icon(
                            Icons.cancel_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        : Text("No encontrado");
  }

  setData(User user) {
    setState(() {
      nombreController.text = user.nombre;
      aPaternoController.text = user.apellidoPaterno;
      aMaternoController.text = user.apellidoMaterno ?? "";
      asignacionController.text = user.asignacion ?? "";

      if (user.maestroVision != null) {
        maestroSelected = Option(
            id: user.maestroVision!.maestroId,
            name:
                "${user.maestroVision!.maestroUser.nombre} ${user.maestroVision!.maestroUser.apellidoPaterno} ${user.maestroVision!.maestroUser.apellidoMaterno}");
      }

      nacimientoController.text = DateFormat('yyyy-MM-dd')
          .format(user.fechaNacimiento ?? DateTime.now());

      telefonoController.text = user.telefono ?? "";
    });
  }

  focusFields() {
    nombreFocus.unfocus();
    aPaternoFocus.unfocus();
    aMaternoFocus.unfocus();
    asignacionFocus.unfocus();
    telefonoFocus.unfocus();
    nacimientoFocus.unfocus();
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
