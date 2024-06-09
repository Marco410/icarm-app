// ignore_for_file: unused_result

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/controllers/betel_controller.dart';
import 'package:icarm/presentation/models/BetelModel.dart';
import 'package:icarm/presentation/providers/betel_provider.dart';
import 'package:icarm/presentation/providers/catalog_service.dart';

import '../../../../config/services/notification_ui_service.dart';
import '../../../../config/setting/style.dart';
import '../../../components/check_box_widget.dart';
import '../../../components/dropdow_options.dart';
import '../../../components/dropdown_widget.dart';
import '../../../components/picker_file_image.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/user_provider.dart';

class AddBetelAdminPage extends ConsumerStatefulWidget {
  final String? type;
  final Betele? betel;

  const AddBetelAdminPage({
    super.key,
    required this.type,
    this.betel,
  });

  @override
  ConsumerState<AddBetelAdminPage> createState() => _AddBetelAdminPageState();
}

class _AddBetelAdminPageState extends ConsumerState<AddBetelAdminPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Option user = Option(id: 0, name: "Seleccione:");
  Option user2 = Option(id: 0, name: "Seleccione:");
  Option userAnf = Option(id: 0, name: "Seleccione:");
  Option userAnf2 = Option(id: 0, name: "Seleccione:");

  final TextEditingController userNameController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  final TextEditingController userName2Controller = TextEditingController();
  FocusNode userName2Focus = FocusNode();
  final TextEditingController userNameAnfController = TextEditingController();
  FocusNode userNameAnfFocus = FocusNode();
  final TextEditingController userNameAnf2Controller = TextEditingController();
  FocusNode userNameAnf2Focus = FocusNode();
  final TextEditingController mapaController = TextEditingController();
  FocusNode mapaFocus = FocusNode();

  final TextEditingController direccionController = TextEditingController();
  FocusNode direccionFocus = FocusNode();
  final TextEditingController telefonoController = TextEditingController();
  FocusNode telefonoFocus = FocusNode();

  bool isPublic = false;
  bool isEditing = false;
  bool isUser = false;
  bool isUser2 = false;
  bool isUserAnf = false;
  bool isUserAnf2 = false;
  bool loadingBetel = false;

  @override
  void initState() {
    isEditing = (widget.type == 'edit');

    print("widget.betel");
    print(widget.betel);

    if (isEditing) {
      setState(() {
        isUser = widget.betel?.user == null;
        if (widget.betel?.user != null) {
          user = Option(
              id: widget.betel!.user!.id,
              name:
                  "${widget.betel!.user!.nombre} ${widget.betel!.user!.apellidoPaterno} ${widget.betel!.user!.apellidoMaterno}");
        } else {
          userNameController.text = widget.betel?.userName ?? "";
        }

        isUser2 = widget.betel?.user2 == null;
        if (widget.betel?.user2 != null) {
          user2 = Option(
              id: widget.betel!.user2!.id,
              name:
                  "${widget.betel!.user2!.nombre} ${widget.betel!.user2!.apellidoPaterno} ${widget.betel!.user2!.apellidoMaterno}");
        } else {
          userName2Controller.text = widget.betel?.user2Name ?? "";
        }

        isUserAnf = widget.betel?.userAnf == null;
        if (widget.betel?.userAnf != null) {
          userAnf = Option(
              id: widget.betel!.userAnf!.id,
              name:
                  "${widget.betel!.userAnf!.nombre} ${widget.betel!.userAnf!.apellidoPaterno} ${widget.betel!.userAnf!.apellidoMaterno}");
        } else {
          userNameAnfController.text = widget.betel?.userAnfName ?? "";
        }

        isUserAnf2 = widget.betel?.userAnf2 == null;
        if (widget.betel?.userAnf2 != null) {
          userAnf2 = Option(
              id: widget.betel!.userAnf2!.id,
              name:
                  "${widget.betel!.userAnf2!.nombre} ${widget.betel!.userAnf2!.apellidoPaterno} ${widget.betel!.userAnf2!.apellidoMaterno}");
        } else {
          userNameAnf2Controller.text = widget.betel?.userAnf2Name ?? "";
        }

        mapaController.text = widget.betel?.mapUrl ?? "";
        direccionController.text = widget.betel?.direccion ?? "";
        telefonoController.text = widget.betel?.telefono ?? "";
      });
    }

    Future.microtask(() => ref.watch(getIglesiasProvider));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usersList = ref.watch(getUserListProvider);
    final imageSelected = ref.watch(imageSelectedProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (widget.type == 'edit')
                          ? "Detalles del betel"
                          : "Nuevo Betel",
                      style: TxtStyle.headerStyle,
                      textAlign: TextAlign.center,
                    ),
                    (widget.type == 'edit')
                        ? IconButton(
                            onPressed: () => setState(() {
                                  isEditing = !isEditing;
                                }),
                            icon: Icon(
                              Icons.edit_rounded,
                              color: ColorStyle.secondaryColor,
                            ))
                        : SizedBox()
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                (!isUser)
                    ? DropdownWidget(
                        title: "Lider",
                        option: user,
                        isRequired: true,
                        readOnly: isEditing,
                        onTapFunction: () async {
                          final res = await showDropdownOptions(
                              context,
                              MediaQuery.of(context).size.height * 0.4,
                              usersList);

                          if (res != null) {
                            setState(() {
                              user = res[0] as Option;
                            });
                          }
                        })
                    : TextFieldWidget(
                        label: 'Lider',
                        border: true,
                        isRequired: true,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: userNameController,
                        focusNode: userNameFocus,
                        readOnly: isEditing,
                      ),
                CheckBoxWidget(
                  text: "No relacionar",
                  value: isUser,
                  onChange: (value) {
                    if (isEditing) return;

                    setState(() {
                      isUser = value!;
                      if (value) {
                        user = Option(id: 0, name: "Seleccione");
                      } else {
                        userNameController.text = "";
                      }
                    });
                  },
                  readOnly: isEditing,
                ),
                (!isUser2)
                    ? DropdownWidget(
                        title: "Lider 2",
                        option: user2,
                        isRequired: false,
                        readOnly: isEditing,
                        onTapFunction: () async {
                          final res = await showDropdownOptions(
                              context,
                              MediaQuery.of(context).size.height * 0.4,
                              usersList);

                          if (res != null) {
                            setState(() {
                              user2 = res[0] as Option;
                            });
                          }
                        })
                    : TextFieldWidget(
                        label: 'Lider 2',
                        border: true,
                        isRequired: false,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: userName2Controller,
                        focusNode: userName2Focus,
                        readOnly: isEditing,
                      ),
                CheckBoxWidget(
                  text: "No relacionar",
                  value: isUser2,
                  onChange: (value) {
                    if (isEditing) return;

                    setState(() {
                      isUser2 = value!;
                      if (value) {
                        user2 = Option(id: 0, name: "Seleccione");
                      } else {
                        userName2Controller.text = "";
                      }
                    });
                  },
                  readOnly: isEditing,
                ),
                (!isUserAnf)
                    ? DropdownWidget(
                        title: "Anfitrión",
                        option: userAnf,
                        isRequired: true,
                        readOnly: isEditing,
                        onTapFunction: () async {
                          final res = await showDropdownOptions(
                              context,
                              MediaQuery.of(context).size.height * 0.4,
                              usersList);

                          if (res != null) {
                            setState(() {
                              userAnf = res[0] as Option;
                            });
                          }
                        })
                    : TextFieldWidget(
                        label: 'Anfitrión',
                        border: true,
                        isRequired: true,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: userNameAnfController,
                        focusNode: userNameAnfFocus,
                        readOnly: isEditing,
                      ),
                CheckBoxWidget(
                  text: "No relacionar",
                  value: isUserAnf,
                  onChange: (value) {
                    if (isEditing) return;

                    setState(() {
                      isUserAnf = value!;
                      if (value) {
                        userAnf = Option(id: 0, name: "Seleccione");
                      } else {
                        userNameAnfController.text = "";
                      }
                    });
                  },
                  readOnly: isEditing,
                ),
                (!isUserAnf2)
                    ? DropdownWidget(
                        title: "Anfitrión 2",
                        option: userAnf2,
                        isRequired: false,
                        readOnly: isEditing,
                        onTapFunction: () async {
                          final res = await showDropdownOptions(
                              context,
                              MediaQuery.of(context).size.height * 0.4,
                              usersList);

                          if (res != null) {
                            setState(() {
                              userAnf2 = res[0] as Option;
                            });
                          }
                        })
                    : TextFieldWidget(
                        label: 'Anfitrión 2',
                        border: true,
                        isRequired: false,
                        textInputType: TextInputType.text,
                        hintText: 'Escribe aquí',
                        controller: userNameAnf2Controller,
                        focusNode: userNameAnf2Focus,
                        readOnly: isEditing,
                      ),
                CheckBoxWidget(
                  text: "No relacionar",
                  value: isUserAnf2,
                  onChange: (value) {
                    if (isEditing) return;

                    setState(() {
                      isUserAnf2 = value!;
                    });
                  },
                  readOnly: isEditing,
                ),
                (imageSelected == null && widget.type != "edit")
                    ? InkWell(
                        onTap: () {
                          PickerFileImage(
                              context, ref, true, false, false, false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: ColorStyle.secondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image_rounded,
                                color: ColorStyle.whiteBacground,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Selecciona una imagen",
                                style: TxtStyle.labelText
                                    .copyWith(color: ColorStyle.whiteBacground),
                              ),
                            ],
                          ),
                        ),
                      )
                    : AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeInOut,
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: SizedBox(
                                        height: 120,
                                        width: 120,
                                        child: (widget.type == "edit")
                                            ? Image.network(
                                                "${URL_MEDIA_BETELES}${widget.betel!.img}",
                                              )
                                            : Image.asset(
                                                imageSelected!.path,
                                                fit: BoxFit.fill,
                                              ))),
                                (widget.type != "edit")
                                    ? Positioned(
                                        top: 0,
                                        right: 10,
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: InkWell(
                                            onTap: () {
                                              ref
                                                  .read(imageSelectedProvider
                                                      .notifier)
                                                  .update((state) => null);
                                            },
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          ],
                        ),
                      ),
                TextFieldWidget(
                  label: 'Url Google Maps',
                  border: true,
                  isRequired: true,
                  textInputType: TextInputType.text,
                  hintText: 'Escribe aquí',
                  controller: mapaController,
                  focusNode: mapaFocus,
                  readOnly: isEditing,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  label: 'Dirección',
                  border: true,
                  isRequired: true,
                  textInputType: TextInputType.text,
                  hintText: 'Escribe aquí',
                  controller: direccionController,
                  focusNode: direccionFocus,
                  readOnly: isEditing,
                  lines: 4,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFieldWidget(
                  label: 'Teléfono',
                  border: true,
                  isRequired: false,
                  textInputType: TextInputType.text,
                  hintText: 'Escribe aquí',
                  controller: telefonoController,
                  focusNode: telefonoFocus,
                  readOnly: isEditing,
                ),
                (!isEditing)
                    ? CustomButton(
                        margin: EdgeInsets.only(
                            bottom: 60, left: 60, right: 60, top: 20),
                        loading: loadingBetel,
                        text:
                            (widget.type == 'edit') ? "Actualizar" : "Guardar",
                        textColor: Colors.white,
                        color: ColorStyle.primaryColor,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (widget.type != 'edit') {
                              if (imageSelected == null) {
                                NotificationUI.instance.notificationWarning(
                                    "Selecciona una imagen");
                                return;
                              }
                            }
                            setState(() => loadingBetel = true);

                            await BetelController.create(
                                    user: user.id.toString(),
                                    userName: userNameController.text,
                                    user2: user2.id.toString(),
                                    user2Name: userName2Controller.text,
                                    userAnf: userAnf.id.toString(),
                                    userAnfName: userNameAnfController.text,
                                    userAnf2: userAnf2.id.toString(),
                                    userAnf2Name: userNameAnf2Controller.text,
                                    img: (imageSelected != null)
                                        ? imageSelected.path
                                        : "",
                                    url_map: mapaController.text,
                                    direccion: direccionController.text,
                                    telefono: telefonoController.text,
                                    betelID: widget.betel?.id.toString(),
                                    editing: widget.type == 'edit')
                                .then((value) {
                              if (value) {
                                ref.refresh(betelesProvider);
                                context.pop();
                                NotificationUI.instance.notificationSuccess(
                                    (widget.type != 'edit')
                                        ? "Betel agregado con éxito"
                                        : "Betel actualizado con éxito");
                                setState(() => loadingBetel = false);
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
    );
  }
}
