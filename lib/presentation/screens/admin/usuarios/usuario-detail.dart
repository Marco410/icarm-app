// ignore_for_file: unused_result

import 'dart:math';

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/user_controller.dart';
import 'package:icarm/presentation/models/UsuarioModel.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/dropdow_options.dart';
import '../../../components/dropdown_widget.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/catalog_service.dart';
import '../../../providers/user_provider.dart';

class UsuarioDetailAdminPage extends ConsumerStatefulWidget {
  final String usuarioID;

  const UsuarioDetailAdminPage({super.key, required this.usuarioID});

  @override
  ConsumerState<UsuarioDetailAdminPage> createState() =>
      _UsuarioDetailAdminPageState();
}

class _UsuarioDetailAdminPageState
    extends ConsumerState<UsuarioDetailAdminPage> {
  var userSelected = Option(id: 0, name: "Seleccione:");
  final TextEditingController msgController = TextEditingController();
  FocusNode msgNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(getIglesiasProvider);
    final user = ref.watch(getUserProvider(widget.usuarioID));
    final editUser = ref.watch(editingUserProvider);

    /* final usersList = ref.watch(getUserListProvider); */
    Random random = new Random();

    return Scaffold(
        backgroundColor: ColorStyle.whiteBacground,
        appBar: AppBarWidget(
          backButton: true,
          rightButtons: false,
        ),
        body: user.when(
          data: (data) {
            if (data == null) {
              return Center(
                child: Text("Usuario no encontrado"),
              );
            }
            return (editUser)
                ? UserDataWidget(
                    user: data,
                    ref: ref,
                    editUser: editUser,
                    onTap: () {
                      ref
                          .read(editingUserProvider.notifier)
                          .update((state) => false);
                    },
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SvgPicture.asset("assets/icon/user-icon.svg",
                            height: 100),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "${data.nombre} ${data.apellidoPaterno} ${data.apellidoMaterno ?? ""}",
                          style: TxtStyle.headerStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text("AYR${random.nextInt(80) + 10}${data.id}"),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ShowDataWidget(
                              title: "Email",
                              data: data.email,
                            ),
                            ShowDataWidget(
                              title: "Teléfono",
                              data: data.telefono ?? "-",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ShowDataWidget(
                              title: "Fecha Nacimiento",
                              data: data.fechaNacimiento != null
                                  ? DateFormat('dd MMMM yyyy')
                                      .format(data.fechaNacimiento!)
                                  : "-",
                            ),
                            ShowDataWidget(
                              title: "Sexo",
                              data: data.sexo != null ? data.sexo!.name : "-",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShowDataWidget(
                              title: "País",
                              data: data.pais != null ? data.pais!.name : "-",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Roles",
                          style: TxtStyle.headerStyle.copyWith(fontSize: 7.sp),
                        ),
                        GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 1,
                                  crossAxisSpacing: 1,
                                  mainAxisExtent: 45),
                          scrollDirection: Axis.vertical,
                          itemCount: data.roles.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: ColorStyle.secondaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                data.roles[index].name,
                                style: TxtStyle.labelText
                                    .copyWith(color: Colors.white),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Iglesia",
                          style: TxtStyle.headerStyle.copyWith(fontSize: 7.sp),
                        ),
                        (data.iglesia != null)
                            ? Text(
                                data.iglesia!.nombre,
                                style: TxtStyle.headerStyle
                                    .copyWith(fontWeight: FontWeight.normal),
                              )
                            : Text("-"),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            size: 'sm',
                            text: "Editar",
                            onTap: () {
                              ref
                                  .read(editingUserProvider.notifier)
                                  .update((state) => true);
                            },
                            textColor: Colors.white,
                            loading: false)
                      ],
                    ),
                  );
          },
          error: (error, stackTrace) => Center(
            child: LoadingStandardWidget.loadingErrorWidget(),
          ),
          loading: () => Center(
            child: LoadingStandardWidget.loadingWidget(),
          ),
        ));
  }
}

// ignore: must_be_immutable
class UserDataWidget extends StatefulWidget {
  final User user;
  final Function onTap;
  final WidgetRef ref;
  bool editUser;
  UserDataWidget(
      {super.key,
      required this.user,
      required this.onTap,
      required this.ref,
      required this.editUser});

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  final TextEditingController nombreController = TextEditingController();
  FocusNode nombreFocus = FocusNode();

  final TextEditingController aPaternoController = TextEditingController();
  final TextEditingController aMaternoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController passConfirmController = TextEditingController();
  final TextEditingController nacimientoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  FocusNode focusTelefono = FocusNode();
  FocusNode aPaternoFocus = FocusNode();
  FocusNode aMaternoFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

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

  Option iglesia = Option(id: 0, name: "Seleccione:");
  Option role = Option(id: 0, name: "Seleccione:");
  List<Role> listRoles = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    nombreController.text = widget.user.nombre;
    aPaternoController.text = widget.user.apellidoPaterno;
    aMaternoController.text = widget.user.apellidoMaterno ?? "";
    emailController.text = widget.user.email;
    nacimientoController.text = DateFormat('yyyy-MM-dd')
        .format(widget.user.fechaNacimiento ?? DateTime.now());
    telefonoController.text = widget.user.telefono ?? "";

    sexo = (widget.user.sexo != null)
        ? Option(id: widget.user.sexo!.id, name: widget.user.sexo!.name)
        : Option(id: 0, name: "Seleccione:");

    pais = (widget.user.pais != null)
        ? Option(id: widget.user.pais!.id, name: widget.user.pais!.name)
        : Option(id: 0, name: "Seleccione:");

    iglesia = (widget.user.iglesia != null)
        ? Option(id: widget.user.iglesia!.id, name: widget.user.iglesia!.nombre)
        : Option(id: 0, name: "Seleccione:");

    listRoles = widget.user.roles;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  unFocusFields() {
    focusTelefono.unfocus();
    nombreFocus.unfocus();
    aPaternoFocus.unfocus();
    aMaternoFocus.unfocus();
    emailFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final iglesiaList = widget.ref.read(iglesiaListProvider);
    final rolesOptions = widget.ref.read(rolesOptionsListProvider);

    return GestureDetector(
      onTap: unFocusFields,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: widget.onTap as void Function(),
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            color: ColorStyle.secondaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 7.sp,
                        ),
                      ),
                    )
                  ],
                ),
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
                  textInputType: TextInputType.emailAddress,
                  label: "Correo Electrónico",
                  hintText: 'Escribe aquí',
                  controller: emailController,
                  focusNode: emailFocus,
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
                  height: 15,
                ),
                TextFieldWidget(
                  border: true,
                  isRequired: true,
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
                  height: 5,
                ),
                DropdownWidget(
                    title: "País",
                    option: pais,
                    isRequired: true,
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
                DropdownWidget(
                    title: "Roles",
                    option: role,
                    isRequired: false,
                    onTapFunction: () async {
                      final res = await showDropdownOptions(
                          context,
                          MediaQuery.of(context).size.height * 0.4,
                          rolesOptions);

                      if (res != null) {
                        role = res[0] as Option;

                        var myListFiltered =
                            listRoles.where((e) => e.name == role.name);

                        if (myListFiltered.length == 0) {
                          setState(() {
                            listRoles.add(Role(
                                id: role.id,
                                name: role.name,
                                guardName: "",
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now()));
                          });
                        }
                        role = Option(id: 0, name: "Seleccione:");
                      }
                    }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(),
                  child: SizedBox(
                    height: 3.5.h,
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listRoles.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                                color: ColorStyle.secondaryColor,
                                borderRadius: BorderRadius.circular(100)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  listRoles[index].name,
                                  style: TxtStyle.labelText.copyWith(
                                      color: Colors.white, fontSize: 4.sp),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      listRoles.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                DropdownWidget(
                    title: "Iglesia",
                    option: iglesia,
                    isRequired: true,
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
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      margin: EdgeInsets.all(10),
                      text: "Cancelar",
                      loading: false,
                      onTap: widget.onTap,
                      color: Colors.grey,
                      textColor: Colors.white,
                    )),
                    Expanded(
                        child: CustomButton(
                      margin: EdgeInsets.all(10),
                      text: "Guardar",
                      loading: loading,
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) {
                          NotificationUI.instance.notificationWarning(
                              "Revisa los datos que ingresaste.");
                          return;
                        }

                        setState(() {
                          loading = true;
                        });

                        await UserController.updateUser(
                                userID: widget.user.id.toString(),
                                nombre: nombreController.text,
                                apellido_paterno: aPaternoController.text,
                                apellido_materno: aMaternoController.text,
                                fecha_nacimiento: nacimientoController.text,
                                email: emailController.text,
                                telefono: telefonoController.text,
                                sexo_id: sexo.id.toString(),
                                pais_id: pais.id.toString(),
                                iglesia_id: iglesia.id.toString(),
                                roles: listRoles)
                            .then((value) {
                          NotificationUI.instance.notificationSuccess(
                              "Datos actualizados con éxito.");
                          widget.ref.refresh(
                              getUserProvider(widget.user.id.toString()));

                          setState(() {
                            loading = false;
                          });

                          widget.ref
                              .read(editingUserProvider.notifier)
                              .update((state) => false);
                        });
                      },
                      textColor: Colors.white,
                      color: ColorStyle.secondaryColor,
                    )),
                  ],
                ),
                SizedBox(
                  height: 100,
                )
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

class ShowDataWidget extends StatelessWidget {
  final String title;
  final String data;

  const ShowDataWidget({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TxtStyle.labelText.copyWith(fontSize: 4.5.sp),
          textAlign: TextAlign.center,
        ),
        Text(
          data,
          textAlign: TextAlign.center,
          style: TxtStyle.labelText
              .copyWith(fontWeight: FontWeight.normal, fontSize: 4.5.sp),
        )
      ],
    );
  }
}
