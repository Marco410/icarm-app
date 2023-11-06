// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/dropdow_options.dart';
import 'package:icarm/presentation/components/text_field.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/models/models.dart';
import 'package:icarm/presentation/providers/kids_service.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    if (widget.kid.id != 0) {
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
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Form(
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
                      final res = await showDropdownOptions(context,
                          MediaQuery.of(context).size.height * 0.4, sexoList);

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
                  text: (widget.type == 'create') ? "Guardar" : "Actualizar",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      if (widget.type == 'create') {
                        ref.refresh(registerKid(KidRegisterData(
                            nombre: nombreController.text,
                            a_paterno: aPaternoController.text,
                            a_materno: aMaternoController.text,
                            fecha_nacimiento: nacimientoController.text,
                            sexo: sexo.name,
                            enfermedad: enfermedadController.text,
                            context: context)));
                      } else {
                        ref.refresh(update_kid(KidRegisterData(
                            kid_id: widget.kid.id,
                            nombre: nombreController.text,
                            a_paterno: aPaternoController.text,
                            a_materno: aMaternoController.text,
                            fecha_nacimiento: nacimientoController.text,
                            sexo: sexo.name,
                            enfermedad: enfermedadController.text,
                            context: context)));
                      }

                      Future.delayed(Duration(seconds: 1), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    } else {
                      NotificationUI.instance.notificationWarning(
                          "Revisa los datos que ingresaste");
                    }
                  },
                  loading: false,
                  textColor: Colors.white,
                ),
                (widget.type == 'edit')
                    ? CustomButton(
                        text: "Eliminar",
                        onTap: () {
                          NotificationUI.instance.notificationToAcceptAction(
                              context, '¿Estás seguro de eliminarlo?', () {
                            setState(() {
                              loadingDelete = true;
                            });

                            ref.refresh(delete_kid(KidRegisterData(
                                kid_id: widget.kid.id, context: context)));

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
