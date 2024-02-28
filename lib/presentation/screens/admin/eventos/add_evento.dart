// ignore_for_file: unused_result

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_rte/flutter_rte.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/evento_controller.dart';
import 'package:icarm/presentation/models/EventoModel.dart';
import 'package:icarm/presentation/providers/catalog_service.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/services/notification_ui_service.dart';
import '../../../../config/setting/style.dart';
import '../../../components/check_box_widget.dart';
import '../../../components/dropdow_options.dart';
import '../../../components/dropdown_widget.dart';
import '../../../components/picker_file_image.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';

class AddEventosAdminPage extends ConsumerStatefulWidget {
  final String? type;
  final Evento? evento;

  const AddEventosAdminPage(
      {super.key, required this.type, required this.evento});

  @override
  ConsumerState<AddEventosAdminPage> createState() =>
      _AddEventosAdminPageState();
}

class _AddEventosAdminPageState extends ConsumerState<AddEventosAdminPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final HtmlEditorController controllerHtml = HtmlEditorController();
  FocusNode nombreFocus = FocusNode();
  FocusNode direccionFocus = FocusNode();

  Option iglesia = Option(id: 0, name: "Seleccione:");

  final TextEditingController fechaInicialController = TextEditingController();
  final TextEditingController fechaFinalController = TextEditingController();

  bool isFavorite = false;
  bool canRegister = false;
  bool direccion = false;
  bool isEditing = false;
  bool loadingEvent = false;

  @override
  void initState() {
    isEditing = (widget.type == 'edit');

    if (widget.evento != null) {
      controllerHtml.setInitialText(widget.evento!.descripcion);
    } else {
      controllerHtml.setInitialText("");
    }
    if (widget.type == 'edit') {
      nombreController.text = widget.evento!.nombre;
      iglesia = Option(
          id: widget.evento!.iglesiaId, name: widget.evento!.iglesia.nombre);

      fechaInicialController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.evento!.fechaInicio);
      fechaFinalController.text =
          DateFormat('yyyy-MM-dd HH:mm').format(widget.evento!.fechaFin);

      direccion = (widget.evento!.direccion == null) ? true : false;

      isFavorite = (widget.evento!.isFavorite == 1) ? true : false;
      canRegister = (widget.evento!.canRegister == 1) ? true : false;
    }

    Future.microtask(() => ref.watch(getIglesiasProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final iglesiaList = ref.read(iglesiaListProvider);

    final imgVertical = ref.watch(imgVerticalProvider);
    final imgHorizontal = ref.watch(imgHorizontalProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      (widget.type == 'edit')
                          ? "Detalles del evento"
                          : "Nuevo Evento",
                      style: TxtStyle.headerStyle,
                      textAlign: TextAlign.center,
                    ),
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
                      readOnly: isEditing,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropdownWidget(
                        title: "Iglesia",
                        option: iglesia,
                        isRequired: true,
                        readOnly: isEditing,
                        onTapFunction: () async {
                          final res = await showDropdownOptions(
                              context,
                              MediaQuery.of(context).size.height * 0.4,
                              iglesiaList);

                          if (res != null) {
                            setState(() {
                              iglesia = res[0] as Option;
                            });
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      label: 'Fecha de inicio',
                      border: true,
                      labelColor: Colors.black,
                      hintText: "aaaa-mm-dd hh:mm",
                      color: Colors.white,
                      controller: fechaInicialController,
                      onTap: () => selectDate(true),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          color: ColorStyle.secondaryColor,
                        ),
                        onPressed: () => selectDate(true),
                      ),
                      readOnly: isEditing,
                      textInputType: TextInputType.datetime,
                      isRequired: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      label: 'Fecha final',
                      border: true,
                      labelColor: Colors.black,
                      hintText: "aaaa-mm-dd hh:mm",
                      color: Colors.white,
                      controller: fechaFinalController,
                      onTap: () => selectDate(false),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          color: ColorStyle.secondaryColor,
                        ),
                        onPressed: () => selectDate(false),
                      ),
                      readOnly: isEditing,
                      textInputType: TextInputType.datetime,
                      isRequired: true,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Descripción del evento *",
                      style: TxtStyle.labelText.copyWith(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: ColorStyle.hintColor),
                          ),
                          child: (!isEditing)
                              ? HtmlEditor(
                                  height: 400,
                                  enableDictation: false,
                                  hint: "Escriba aquí los detalles del evento.",
                                  controller: controllerHtml,
                                )
                              : Html(data: widget.evento!.descripcion),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CheckBoxWidget(
                      text: "¿El evento será en la iglesia?",
                      value: direccion,
                      onChange: (value) {
                        if (isEditing) return;
                        setState(() {
                          direccion = value!;
                        });
                      },
                      readOnly: isEditing,
                    ),
                    (!direccion)
                        ? TextFieldWidget(
                            label: 'Dirección del evento',
                            border: true,
                            isRequired: true,
                            textInputType: TextInputType.text,
                            hintText: 'Escribe aquí',
                            controller: direccionController,
                            focusNode: direccionFocus,
                            lines: 4,
                            readOnly: isEditing,
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    (widget.type == 'edit')
                        ? Column(
                            children: [
                              Text(
                                "Imágenes",
                                style: TxtStyle.headerStyle,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${URL_MEDIA_EVENTO}/${widget.evento!.id}/${widget.evento!.imgHorizontal}",
                                      placeholder: (context, url) =>
                                          LoadingStandardWidget.loadingWidget(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 40.sp,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      height: 28.sp,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${URL_MEDIA_EVENTO}/${widget.evento!.id}/${widget.evento!.imgVertical}",
                                      placeholder: (context, url) =>
                                          LoadingStandardWidget.loadingWidget(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 28.sp,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      height: 40.sp,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),
                    (widget.type != 'edit')
                        ? (imgHorizontal == null)
                            ? InkWell(
                                onTap: () {
                                  PickerFileImage(
                                      context, ref, true, false, true, false);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.secondaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icon/images.svg",
                                        height: 30,
                                        // ignore: deprecated_member_use
                                        color: ColorStyle.secondaryColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Imagen Horizontal",
                                        style: TxtStyle.labelText,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 23,
                                        width: 35,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: ColorStyle.secondaryColor),
                                        child: Icon(
                                          Icons.arrow_drop_up_rounded,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: 80.h,
                                height: 25,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      color: ColorStyle.secondaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Imagen horizontal seleccionada.",
                                      style: TxtStyle.labelText,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ref
                                            .read(
                                                imgHorizontalProvider.notifier)
                                            .update((state) => null);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red[400],
                                      ),
                                    )
                                  ],
                                ))
                        : SizedBox(),
                    SizedBox(
                      height: 15,
                    ),
                    (widget.type != 'edit')
                        ? (imgVertical == null)
                            ? InkWell(
                                onTap: () {
                                  PickerFileImage(
                                      context, ref, true, false, false, true);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: ColorStyle.secondaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icon/images.svg",
                                        height: 30,
                                        // ignore: deprecated_member_use
                                        color: ColorStyle.secondaryColor,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Imagen Vertical",
                                        style: TxtStyle.labelText,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 35,
                                        width: 23,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: ColorStyle.secondaryColor),
                                        child: Icon(
                                          Icons.arrow_drop_up_rounded,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: 80.h,
                                height: 25,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      color: ColorStyle.secondaryColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Imagen vertical seleccionada.",
                                      style: TxtStyle.labelText,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ref
                                            .read(imgVerticalProvider.notifier)
                                            .update((state) => null);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red[400],
                                      ),
                                    )
                                  ],
                                ))
                        : SizedBox(),
                    CheckBoxWidget(
                      text: "Mostrar en la pantalla de inicio",
                      value: isFavorite,
                      onChange: (value) {
                        if (isEditing) return;

                        setState(() {
                          isFavorite = value!;
                        });
                      },
                      readOnly: isEditing,
                    ),
                    CheckBoxWidget(
                      text: "Mostrar registro",
                      value: canRegister,
                      onChange: (value) {
                        if (isEditing) return;

                        setState(() {
                          canRegister = value!;
                        });
                      },
                      readOnly: isEditing,
                    ),
                    (!isEditing)
                        ? CustomButton(
                            margin: EdgeInsets.only(
                                bottom: 60, left: 60, right: 60, top: 20),
                            loading: loadingEvent,
                            text: (widget.type == 'edit')
                                ? "Actualizar"
                                : "Guardar",
                            textColor: Colors.white,
                            color: ColorStyle.secondaryColor,
                            onTap: () async {
                              if (fechaInicialController.text == "" ||
                                  fechaFinalController.text == "") {
                                NotificationUI.instance.notificationWarning(
                                    "Agrega la fecha del evento");

                                return;
                              }

                              if (_formKey.currentState!.validate()) {
                                var dateIni =
                                    DateTime.parse(fechaInicialController.text);
                                var dateFin =
                                    DateTime.parse(fechaFinalController.text);
                                if (dateIni.isAfter(dateFin) ||
                                    dateIni.isAtSameMomentAs(dateFin)) {
                                  NotificationUI.instance.notificationWarning(
                                      "La fecha final debe de ser después de la fecha inicial.");

                                  return;
                                }

                                if (controllerHtml.contentIsEmpty) {
                                  NotificationUI.instance.notificationWarning(
                                      "Agrega una descripción al evento");

                                  return;
                                }

                                if (controllerHtml.contentIsEmpty) {
                                  NotificationUI.instance.notificationWarning(
                                      "Agrega una descripción al evento");
                                  return;
                                }

                                if (widget.type != 'edit') {
                                  if (imgVertical == null ||
                                      imgHorizontal == null) {
                                    NotificationUI.instance.notificationWarning(
                                        "Agrega alguna imagen al evento");
                                    return;
                                  }
                                }

                                setState(() => loadingEvent = true);

                                await EventoController.createEvent(
                                        nombre: nombreController.text,
                                        iglesiaID: iglesia.id.toString(),
                                        fechaInicio:
                                            fechaInicialController.text,
                                        fechaFin: fechaFinalController.text,
                                        descripcion: controllerHtml.content,
                                        direccion: direccionController.text,
                                        isFavorite: isFavorite,
                                        canRegister: canRegister,
                                        imgVertical: (widget.type != 'edit')
                                            ? imgVertical!.path
                                            : null,
                                        imgHorizontal: (widget.type != 'edit')
                                            ? imgHorizontal!.path
                                            : null,
                                        eventoID: (widget.type == 'edit')
                                            ? widget.evento!.id.toString()
                                            : null,
                                        editing: widget.type == 'edit')
                                    .then((value) {
                                  if (value) {
                                    ref.refresh(getEventosProvider);
                                    context.pop();
                                    NotificationUI.instance.notificationSuccess(
                                        (widget.type != 'edit')
                                            ? "Evento agregado con éxito"
                                            : "Evento actualizado con éxito");
                                    setState(() => loadingEvent = false);
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
            (widget.type == 'edit')
                ? Positioned(
                    top: 0,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        setState(() => isEditing = !isEditing);
                        controllerHtml
                            .setInitialText(widget.evento!.descripcion);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: (isEditing)
                                ? ColorStyle.primaryColor
                                : ColorStyle.secondaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }

  selectDate(bool inicial) async {
    if (isEditing) {
      return;
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 40.h,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              CupertinoDatePicker(
                minimumDate: DateTime.now().subtract(Duration(days: 1)),
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDateTime) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd HH:mm').format(newDateTime);

                  setState(() {
                    if (inicial) {
                      fechaInicialController.text = formattedDate;
                    } else {
                      fechaFinalController.text = formattedDate;
                    }
                  });
                },
                use24hFormat: false,
                minuteInterval: 1,
              ),
              Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: ColorStyle.secondaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ))
            ],
          ),
        );
      },
    );

    /*  DateTime? pickedDate = await showDatePicker(
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
    } */
  }
}
