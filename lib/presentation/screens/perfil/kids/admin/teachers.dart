// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';

import '../../../../../config/share_prefs/prefs_usuario.dart';
import '../../../../components/views/data_kid.dart';
import '../../../../providers/teacher_kids_provider.dart';

class TeachersPage extends ConsumerStatefulWidget {
  const TeachersPage({super.key});

  @override
  ConsumerState<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends ConsumerState<TeachersPage> {
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final teachers = ref.watch(getTeacherListProvider);
    final openList = ref.watch(openTeacherProvider);

    Future<void> onRefresh(WidgetRef ref) async {
      // ignore: unused_result
      ref.refresh(getTeacherListProvider);
    }

    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 0, right: 0),
        child: RefreshIndicator(
          color: ColorStyle.primaryColor,
          onRefresh: () => onRefresh(ref),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Hola ${prefs.nombre} bienvenido.",
                    style: TxtStyle.headerStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Aquí podrás ver los maestros de niños. En cada uno podras ver los niños que están en su salón.",
                    style: TxtStyle.hintText,
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Maestros:",
                  style: TxtStyle.headerStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: teachers.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return LoadingStandardWidget.loadingNoDataWidget(
                            "maestros");
                      }

                      return RefreshIndicator(
                        color: ColorStyle.primaryColor,
                        onRefresh: () => onRefresh(ref),
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (() {
                                setState(() {
                                  openList[index] = !openList[index];
                                });

                                ref
                                    .read(openTeacherProvider.notifier)
                                    .update((state) => openList);
                              }),
                              child: AccordionWidget(
                                onTap: () {},
                                title: "${data[index].nombre} ",
                                subtitle:
                                    "${data[index].apellidoPaterno} ${data[index].apellidoMaterno}",
                                isOpen: openList[index],
                                content: (data[index].classroom!.length != 0)
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(0),
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            data[index].classroom!.length,
                                        itemBuilder:
                                            (BuildContext context, int indexC) {
                                          return InkWell(
                                            onTap: () {
                                              DataKid(
                                                  context,
                                                  ref,
                                                  data[index]
                                                      .classroom![indexC]);
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        spreadRadius: -9,
                                                        offset: Offset(0, -1))
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Icon(
                                                        (data[index]
                                                                    .classroom![
                                                                        indexC]
                                                                    .kid
                                                                    .sexo ==
                                                                'Hombre')
                                                            ? Icons.face_rounded
                                                            : Icons
                                                                .face_2_rounded,
                                                        color: ColorStyle
                                                            .secondaryColor,
                                                        size: 30,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 30,
                                                    ),
                                                    Expanded(
                                                      flex: 10,
                                                      child: Text(
                                                        "${data[index].classroom![indexC].kid.nombre} ${data[index].classroom![indexC].kid.aPaterno} ${data[index].classroom![indexC].kid.aMaterno}",
                                                        overflow:
                                                            TextOverflow.fade,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Icon(Icons
                                                            .arrow_forward_ios_rounded))
                                                  ],
                                                )),
                                          );
                                        })
                                    : Text(
                                        "No hay niños en su salón.",
                                        style: TxtStyle.hintText,
                                      ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (_, __) =>
                        LoadingStandardWidget.loadingErrorWidget(),
                    loading: () => Center(
                      child: LoadingStandardWidget.loadingWidget(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
