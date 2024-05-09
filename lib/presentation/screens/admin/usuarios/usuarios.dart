// ignore_for_file: unused_result

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/models/DefaultsModel.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/text_field.dart';
import '../../../components/zcomponents.dart';
import '../../../providers/user_provider.dart';

class UsuariosAdminPage extends ConsumerStatefulWidget {
  const UsuariosAdminPage({super.key});

  @override
  ConsumerState<UsuariosAdminPage> createState() => _UsuariosAdminPageState();
}

class _UsuariosAdminPageState extends ConsumerState<UsuariosAdminPage> {
  final TextEditingController msgController = TextEditingController();
  FocusNode msgNode = FocusNode();
  String roleSelected = "";
  @override
  void initState() {
    Future.microtask(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(getUsersAllProvider);
    ref.watch(getRolesProvider);

    final roles = ref.read(rolesListProvider);

    /* final usersList = ref.watch(getUserListProvider); */

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      /*   floatingActionButton: InkWell(
        /*  onTap: () =>
            context.pushNamed('new.evento', pathParameters: {"type": 'new'}), */
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: ColorStyle.secondaryColor,
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            )),
      ), */
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                margin:
                    EdgeInsets.only(right: 15, left: 15, bottom: 10, top: 5),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 7,
                          spreadRadius: -3,
                          offset: Offset(0, 0))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 8,
                        child: TextFieldWidget(
                          margin: EdgeInsets.all(0),
                          border: false,
                          isRequired: false,
                          textInputType: TextInputType.text,
                          hintText: 'Buscar...',
                          focusNode: msgNode,
                          controller: msgController,
                          capitalize: false,
                          onTyping: (type) {
                            ref.read(filterUsersProvider.notifier).update(
                                (state) => FilterUser(
                                    nombre: type, role: roleSelected));
                            ref.refresh(getUsersAllProvider);
                          },
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                                padding: EdgeInsets.all(0),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Icon(Icons.search)),
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(),
                child: SizedBox(
                  height: 3.5.h,
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: roles.length,
                    itemBuilder: (context, index) {
                      bool selected = roleSelected == roles[index].name;

                      return FadedScaleAnimation(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (roleSelected == roles[index].name) {
                                roleSelected = "";
                                selected = false;
                              } else {
                                roleSelected = roles[index].name;
                              }
                            });

                            ref.read(filterUsersProvider.notifier).update(
                                (state) => FilterUser(
                                    nombre: msgController.text,
                                    role: roleSelected));
                            ref.refresh(getUsersAllProvider);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 15),
                            decoration: BoxDecoration(
                                color: (selected)
                                    ? ColorStyle.secondaryColor
                                    : ColorStyle.hintDarkColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              roles[index].name,
                              style: TxtStyle.labelText.copyWith(
                                  color: Colors.white, fontSize: 4.sp),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
          users.when(
            data: (data) {
              if (data.length == 0) {
                return Expanded(
                  flex: 10,
                  child: Center(
                    child: LoadingStandardWidget.loadingEmptyWidget(),
                  ),
                );
              }
              return Expanded(
                flex: 10,
                child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FadeAnimation(
                        child: InkWell(
                          onTap: () => context.pushNamed('usuario.detail',
                              pathParameters: {
                                'usuarioID': data[index].id.toString()
                              }),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: -4,
                                    offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 75.w,
                                      child: Text(
                                        "${data[index].nombre} ${data[index].apellidoPaterno} ${data[index].apellidoMaterno}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TxtStyle.labelText.copyWith(
                                            color: ColorStyle.primaryColor,
                                            fontSize: 5.5.sp),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 75.w,
                                      child: Text(
                                        data[index]
                                            .roles
                                            .map((e) => e.name)
                                            .join(" | "),
                                        overflow: TextOverflow.ellipsis,
                                        style: TxtStyle.hintText,
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorStyle.primaryColor,
                                  size: 9.sp,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            },
            error: (error, stackTrace) {
              return Expanded(
                  flex: 10,
                  child: Center(
                      child: LoadingStandardWidget.loadingErrorWidget()));
            },
            loading: () {
              return Expanded(
                  flex: 10, child: LoadingStandardWidget.loadingWidget());
            },
          ),
        ],
      ),
    );
  }
}
