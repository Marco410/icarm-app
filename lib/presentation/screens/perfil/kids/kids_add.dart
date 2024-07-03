// ignore_for_file: unused_result, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/controllers/kids_controller.dart';
import 'package:icarm/presentation/models/models.dart';
import 'package:icarm/presentation/providers/kids_service.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../components/dropdown_widget.dart';
import '../../../models/kids/kidsModel.dart';

class KidsAddPage extends ConsumerStatefulWidget {
  final String type;
  final Kid kid;
  const KidsAddPage({super.key, required this.type, required this.kid});

  @override
  ConsumerState<KidsAddPage> createState() => _KidsAddPageState();
}

class _KidsAddPageState extends ConsumerState<KidsAddPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();
  final TextEditingController enfermedadController = TextEditingController();

  FocusNode nombreFocus = FocusNode();
  FocusNode aPaternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();
  FocusNode enfermedadFocus = FocusNode();

  Option sexo = Option(id: 0, name: "Seleccione");
  List<Option> sexoList = [
    Option(id: 1, name: "Hombre"),
    Option(id: 2, name: "Mujer")
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool loading = false;
  bool loadingDelete = false;

  bool update = false;

  @override
  void initState() {
    if (widget.kid.id != 0) {
      setState(() {
        update = true;
      });
      nombreController.text = widget.kid.nombre;
      aPaternoController.text = widget.kid.aPaterno;
      aMaternoController.text = widget.kid.aMaterno;
      nacimientoController.text = DateFormat("yyyy-MM-dd")
          .format(widget.kid.fechaNacimiento)
          .toString();
      sexo = Option(
          id: (widget.kid.sexo == 'Hombre') ? 1 : 2,
          name: (widget.kid.sexo == 'Hombre') ? 'Hombre' : 'Mujer');

      enfermedadController.text = widget.kid.enfermedad;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final update = ref.watch(updateKidProvider);
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: (update)
              ? KidViewWidget(
                  kid: widget.kid,
                  ref: ref,
                  onTap: () {
                    setState(() {
                      update = !update;
                    });
                  },
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        label: 'Nombre',
                        border: true,
                        isRequired: true,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: nombreController,
                        focusNode: nombreFocus,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        label: 'Apellido Paterno',
                        border: true,
                        isRequired: true,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: aPaternoController,
                        focusNode: aPaternoFocus,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        label: 'Apellido Materno',
                        border: true,
                        isRequired: false,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: aMaternoController,
                        focusNode: aMaternoFocus,
                      ),
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
                      SizedBox(
                        height: 5,
                      ),
                      DropdownWidget(
                          title: "Sexo",
                          option: sexo,
                          isRequired: true,
                          onTapFunction: () async {
                            final res = await showDropdownOptions(
                                context,
                                MediaQuery.of(context).size.height * 0.4,
                                sexoList);

                            if (res != null) {
                              setState(() {
                                sexo = res[0] as Option;
                              });
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldWidget(
                        label: '¿Padece alguna enfermedad?',
                        border: true,
                        labelColor: Colors.black,
                        hintText: "Escribe aquí",
                        color: Colors.white,
                        controller: enfermedadController,
                        readOnly: false,
                        textInputType: TextInputType.text,
                        isRequired: false,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomButton(
                        text: (widget.type == 'create')
                            ? "Guardar"
                            : "Actualizar",
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            if (widget.type == 'create') {
                              KidsController.registerKid(
                                      nombre: nombreController.text,
                                      a_paterno: aPaternoController.text,
                                      a_materno: aMaternoController.text,
                                      fecha_nacimiento:
                                          nacimientoController.text,
                                      sexo: sexo.name,
                                      enfermedad: enfermedadController.text)
                                  .then((value) {
                                if (value) {
                                  context.pop();
                                  ref.refresh(getKidsProvider(prefs.usuarioID));
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              });
                            } else {
                              KidsController.updateKid(
                                kid_id: widget.kid.id.toString(),
                                nombre: nombreController.text,
                                a_paterno: aPaternoController.text,
                                a_materno: aMaternoController.text,
                                fecha_nacimiento: nacimientoController.text,
                                sexo: sexo.name,
                                enfermedad: enfermedadController.text,
                              ).then((value) {
                                if (value) {
                                  context.pop();
                                  ref.refresh(getKidsProvider(prefs.usuarioID));
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              });
                            }
                          } else {
                            NotificationUI.instance.notificationWarning(
                                "Revisa los datos que ingresaste");
                          }
                        },
                        loading: loading,
                        textColor: Colors.white,
                      ),
                      (widget.type == 'edit')
                          ? CustomButton(
                              text: "Cancelar",
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 35),
                              onTap: () {
                                setState(() {
                                  update = !update;
                                });
                              },
                              textColor: Colors.white,
                              color: ColorStyle.hintDarkColor,
                              loading: false)
                          : SizedBox(),
                      (widget.type == 'edit')
                          ? CustomButton(
                              text: "Eliminar",
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 35),
                              onTap: () {
                                NotificationUI.instance
                                    .notificationToAcceptAction(
                                        context, '¿Estás seguro de eliminarlo?',
                                        () {
                                  setState(() {
                                    loadingDelete = true;
                                  });

                                  ref.refresh(delete_kid(KidRegisterData(
                                      kid_id: widget.kid.id,
                                      context: context)));

                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      loadingDelete = false;
                                      context.pop();
                                    });
                                  });
                                });
                              },
                              loading: loadingDelete,
                              color: Colors.red[300],
                              textColor: Colors.white)
                          : SizedBox(),
                    ],
                  ),
                ),
        ),
      ),
    );
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

class KidViewWidget extends StatefulWidget {
  final Kid kid;
  WidgetRef ref;
  Function onTap;
  KidViewWidget(
      {super.key, required this.kid, required this.ref, required this.onTap});

  @override
  State<KidViewWidget> createState() => _KidViewWidgetState();
}

class _KidViewWidgetState extends State<KidViewWidget> {
  @override
  Widget build(BuildContext context) {
    Random random = new Random();

    final qrData = "KID${random.nextInt(80) + 10}${widget.kid.id}";

    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.kid.nombre,
            style: TxtStyle.headerStyle,
          ),
          Text(
            "${widget.kid.aPaterno} ${widget.kid.aMaterno}",
            style: TxtStyle.headerStyle,
          ),
          SizedBox(
            height: 20,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 250,
              backgroundColor: Colors.white,
              embeddedImageStyle: QrEmbeddedImageStyle(color: Colors.white),
              constrainErrorBounds: true,
              padding: EdgeInsets.all(20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            qrData,
            style: TxtStyle.hintText,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Muestra este QR para dejar a tu hijo en la escuela de la iglesia.",
            style: TxtStyle.labelText,
            textAlign: TextAlign.center,
          ),
          CustomButton(
            text: "Editar",
            onTap: widget.onTap as void Function(),
            loading: false,
            color: ColorStyle.secondaryColor,
            textColor: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          ),
          (widget.kid.imtutor != null && !widget.kid.imtutor!)
              ? CustomButton(
                  text: "Mostrar código a tutor",
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: false,
                        builder: (context) {
                          String code =
                              "${random.nextInt(80) + 10}${random.nextInt(80) + 10}";

                          KidsController.generateCode(
                              code: code,
                              kid_id: widget.kid.id.toString(),
                              usuarioID: prefs.usuarioID);

                          return StatefulBuilder(builder: (ctx, setState) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              height: 90.h,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Código",
                                        style: TxtStyle.headerStyle
                                            .copyWith(fontSize: 25),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            KidsController.invalidarCode(
                                                    kid_id: widget.kid.id
                                                        .toString())
                                                .then((value) => context.pop());
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                color:
                                                    ColorStyle.secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          )),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 20.h,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: ColorStyle.hintLightColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(code,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(height: 15),
                                  Spacer(),
                                  Text(
                                    "Mantén esta ventana abierta para que el código sea válido.",
                                    style: TxtStyle.hintText.copyWith(
                                        color: ColorStyle.secondaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Por favor, comparte este código con el tutor que desees añadir, así él también podrá llevar al niño a la escuela.",
                                    style: TxtStyle.hintText
                                        .copyWith(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                        enableDrag: false);
                  },
                  loading: false,
                  color: ColorStyle.primaryColor,
                  textColor: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
