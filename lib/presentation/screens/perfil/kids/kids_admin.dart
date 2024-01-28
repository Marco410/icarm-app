// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';

import '../../../../config/share_prefs/prefs_usuario.dart';
import '../../../components/views/data_kid.dart';
import '../../../providers/teacher_kids_provider.dart';

class KidsAdminPage extends ConsumerStatefulWidget {
  const KidsAdminPage({super.key});

  @override
  ConsumerState<KidsAdminPage> createState() => _KidsAdminPageState();
}

class _KidsAdminPageState extends ConsumerState<KidsAdminPage> {
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final kidsInClass = ref.watch(getKidsInClassroomProvider(prefs.usuarioID));

    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 30, right: 30),
        child: RefreshIndicator(
          onRefresh: () => refreshChilds(ref),
          color: ColorStyle.primaryColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Maestro ${prefs.nombre} bienvenido.",
                  style: TxtStyle.headerStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "En este espacio tú como maestro podrás escanear el código QR de los papás que vengan, una vez escaneado, seleccionarás al niño que entrará, después se te añadirá el niño en la parte de abajo, con esto podrás tener el control de los niños y llamar a sus padres en caso de que sea necesario.",
                  style: TxtStyle.hintText,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                    text: "Recibir niño",
                    onTap: () {
                      context.pushNamed('scanner',
                          pathParameters: {"type": "kids"});
                    },
                    textColor: Colors.white,
                    margin: EdgeInsets.all(10),
                    loading: false),
                (prefs.usuarioRol.contains('1') ||
                        prefs.usuarioRol.contains('4'))
                    ? CustomButton(
                        text: "Ver los maestros",
                        onTap: () {
                          context.pushNamed('teachers');
                        },
                        textColor: Colors.white,
                        margin: EdgeInsets.all(10),
                        loading: false)
                    : SizedBox(),
                Text(
                  "Niños en tu salón:",
                  style: TxtStyle.headerStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                kidsInClass.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: LoadingStandardWidget.loadingNoDataWidget(
                            "niños en el salón"),
                      );
                    }

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              DataKid(context, ref, data[index]);
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 10,
                                        spreadRadius: -9,
                                        offset: Offset(0, -1))
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Icon(
                                        (data[index].kid.sexo == 'Hombre')
                                            ? Icons.face_rounded
                                            : Icons.face_2_rounded,
                                        color: ColorStyle.secondaryColor,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Text(
                                        "${data[index].kid.nombre} ${data[index].kid.aPaterno} ${data[index].kid.aMaterno}",
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Icon(
                                            Icons.arrow_forward_ios_rounded))
                                  ],
                                )),
                          );
                        },
                      ),
                    );
                  },
                  error: (_, __) => LoadingStandardWidget.loadingErrorWidget(),
                  loading: () => Center(
                    child: LoadingStandardWidget.loadingWidget(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refreshChilds(WidgetRef ref) async {
    ref.refresh(getKidsInClassroomProvider(prefs.usuarioID));
  }
}
