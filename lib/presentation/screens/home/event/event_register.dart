// ignore_for_file: unused_result

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/providers/catalog_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/services/notification_ui_service.dart';
import '../../../../config/setting/style.dart';
import '../../../components/check_box_widget.dart';
import '../../../components/dropdow_options.dart';
import '../../../components/dropdown_widget.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';
import '../../../controllers/evento_controller.dart';

class EventRegisterScreen extends ConsumerStatefulWidget {
  final String eventoID;
  final String type;
  final String toRegister;

  const EventRegisterScreen(
      {super.key,
      required this.eventoID,
      required this.type,
      required this.toRegister});

  @override
  ConsumerState<EventRegisterScreen> createState() =>
      _EventRegisterScreenState();
}

class _EventRegisterScreenState extends ConsumerState<EventRegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController refNombreController = TextEditingController();
  final TextEditingController refTelefonoController = TextEditingController();

  final TextEditingController direccionController = TextEditingController();
  FocusNode nombreFocus = FocusNode();
  FocusNode aPeternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode edadFocus = FocusNode();
  FocusNode telefonoFocus = FocusNode();
  FocusNode refNombreFocus = FocusNode();
  FocusNode refTelefonoFocus = FocusNode();

  Option genero = Option(id: 0, name: "Seleccione:");
  Option estado = Option(id: 0, name: "Seleccione:");

  bool aceptTerms = false;
  bool isEditing = false;
  String msjDirigir = "Mi invitado esta de acuerdo con los";

  final HtmlEditorController controllerHtml = HtmlEditorController();

  @override
  void initState() {
    if (widget.toRegister == 'self') {
      nombreController.text = prefs.nombre;
      aPaternoController.text = prefs.aPaterno;
      aMaternoController.text = prefs.aMaterno;
      telefonoController.text = prefs.telefono;
      msjDirigir = "Estoy de acuerdo con los";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        edadFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        appBar: AppBarWidget(
          backButton: true,
          rightButtons: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Registrar Invitado",
                    style: TxtStyle.headerStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFieldWidget(
                    label: 'Nombre(s)',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    hintText: 'Escribe aquí',
                    controller: nombreController,
                    focusNode: nombreFocus,
                    readOnly: isEditing,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    label: 'Apellido Paterno',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    hintText: 'Escribe aquí',
                    controller: aPaternoController,
                    focusNode: aPeternoFocus,
                    readOnly: isEditing,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    label: 'Apellido Materno',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    hintText: 'Escribe aquí',
                    controller: aMaternoController,
                    focusNode: aMaternoFocus,
                    readOnly: isEditing,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    label: "Correo Electrónico",
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.emailAddress,
                    hintText: 'Escribe aquí',
                    controller: emailController,
                    focusNode: emailFocus,
                    autoFillHints: AutofillHints.username,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    label: 'Edad',
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.number,
                    hintText: 'Escribe aquí',
                    controller: edadController,
                    focusNode: edadFocus,
                    readOnly: isEditing,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownWidget(
                      title: "Género",
                      option: genero,
                      isRequired: true,
                      readOnly: isEditing,
                      onTapFunction: () async {
                        final res = await showDropdownOptions(
                            context, MediaQuery.of(context).size.height * 0.4, [
                          Option(id: 1, name: 'Hombre'),
                          Option(id: 2, name: 'Mujer')
                        ]);

                        if (res != null) {
                          setState(() {
                            genero = res[0] as Option;
                          });
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  DropdownWidget(
                      title: "Estado civil",
                      option: estado,
                      isRequired: true,
                      readOnly: isEditing,
                      onTapFunction: () async {
                        final res = await showDropdownOptions(
                            context, MediaQuery.of(context).size.height * 0.4, [
                          Option(id: 1, name: 'Soltero'),
                          Option(id: 2, name: 'Casado'),
                          Option(id: 3, name: 'Divorciado'),
                          Option(id: 4, name: 'Unión Libre'),
                          Option(id: 5, name: 'Viudo'),
                        ]);

                        if (res != null) {
                          setState(() {
                            estado = res[0] as Option;
                          });
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.number,
                    label: "Teléfono",
                    hintText: 'Escribe aquí',
                    controller: telefonoController,
                    focusNode: telefonoFocus,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.text,
                    label: "Referencia Familiar",
                    hintText: 'Escribe aquí el nombre',
                    controller: refNombreController,
                    focusNode: refNombreFocus,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                    border: true,
                    isRequired: true,
                    textInputType: TextInputType.number,
                    hintText: 'Escribe aquí el teléfono',
                    controller: refTelefonoController,
                    focusNode: refTelefonoFocus,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CheckBoxWidget(
                              text: "",
                              value: aceptTerms,
                              onChange: (value) {
                                if (isEditing) return;

                                setState(() {
                                  aceptTerms = value!;
                                });
                              },
                              readOnly: false,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap: () {
                                // ignore: deprecated_member_use
                                launch(
                                    "https://www.amoryrestauracionmorelia.org/");
                              },
                              child: Text(
                                "$msjDirigir términos y condiciones",
                                style: TxtStyle.labelText.copyWith(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  (widget.type != 'edit')
                      ? CustomButton(
                          margin: EdgeInsets.only(
                              bottom: 60, left: 60, right: 60, top: 20),
                          loading: false,
                          text: (widget.type == 'edit')
                              ? "Actualizar"
                              : "Guardar",
                          textColor: Colors.white,
                          color: ColorStyle.secondaryColor,
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              if (!aceptTerms) {
                                NotificationUI.instance.notificationWarning(
                                    "Debes de aceptar los términos.");
                                return;
                              }

                              if (int.parse(edadController.text) <= 14) {
                                NotificationUI.instance.notificationWarning(
                                    "La edad debe ser mayor a 15 años.");
                                return;
                              }

                              await EventoController.createNewRegister(
                                usuarioID: (widget.toRegister == 'self')
                                    ? prefs.usuarioID
                                    : null,
                                usuarioInvitedID: prefs.usuarioID,
                                eventoID: widget.eventoID,
                                nombre: nombreController.text,
                                aPaterno: aPaternoController.text,
                                aMaterno: aMaternoController.text,
                                email: emailController.text,
                                edad: edadController.text,
                                genero: genero.name,
                                estadoCivil: estado.name,
                                telefono: telefonoController.text,
                                refNombre: refNombreController.text,
                                refTelefono: refTelefonoController.text,
                              ).then((value) {
                                if (value) {
                                  NotificationUI.instance.notificationSuccess(
                                      "Encontrado registrado con éxito. Revisa la lista de tus invitados.");

                                  context.pop();
                                }
                              });
                            } else {
                              NotificationUI.instance.notificationWarning(
                                  "Revisa los datos que ingresaste");
                            }
                          },
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
