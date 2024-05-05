// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/controllers/kids_controller.dart';
import 'package:icarm/presentation/providers/kids_service.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../models/kids/kidsModel.dart';

class KidsPage extends ConsumerStatefulWidget {
  const KidsPage({super.key});

  @override
  ConsumerState<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends ConsumerState<KidsPage> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kidsList = ref.watch(getKidsProvider(prefs.usuarioID));

    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/image/kids.png"),
              Image.asset(
                "assets/image/logo-kids.png",
                scale: 1.5,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Text(
                  "Registra a tus hijos",
                  style: TxtStyle.headerStyle,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Pases de lista, eventos y más",
                  style: TxtStyle.hintText,
                ),
                (prefs.usuarioRol.contains('1') ||
                        prefs.usuarioRol.contains('6'))
                    ? CustomButton(
                        text: "Administración de niños",
                        margin: EdgeInsets.only(
                            top: 5, bottom: 5, left: 30, right: 30),
                        onTap: () {
                          context.pushNamed('kidsAdmin');
                        },
                        color: ColorStyle.primaryColor,
                        textColor: Colors.white,
                        loading: false)
                    : SizedBox(),
                LineWidget(),
              ],
            ),
          ),
          kidsList.when(
              data: (data) {
                if (data!.isEmpty) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingStandardWidget.loadingNoDataWidget(
                          "hijos registrados"),
                    ),
                  );
                } else {
                  return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(0),
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return RefreshIndicator(
                              onRefresh: () => refresKids(ref),
                              child: KidLinkWidget(
                                kid: data[index],
                                ref: ref,
                              ),
                            );
                          }));
                }
              },
              error: (_, __) => LoadingStandardWidget.loadingErrorWidget(),
              loading: () =>
                  Expanded(child: LoadingStandardWidget.loadingWidget())),
          CustomButton(
            text: "Registrar a mi hijo",
            onTap: () {
              ref.read(updateKidProvider.notifier).update((state) => false);

              context.pushNamed('kidsAdd', pathParameters: {'type': 'create'});
            },
            loading: false,
            textColor: Colors.white,
            color: ColorStyle.secondaryColor,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          CustomButton(
            text: "Añadir por código de tutor",
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (ctx, setState) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      height: 40.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Código",
                                style:
                                    TxtStyle.headerStyle.copyWith(fontSize: 25),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: List.generate(
                                4,
                                (index) => Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            top: 0,
                                            bottom: 10,
                                            right: 5),
                                        margin: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: ColorStyle.hintLightColor,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: TextField(
                                          maxLength: 1,
                                          controller: _controllers[index],
                                          focusNode: _focusNodes[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.top,
                                          style: TextStyle(
                                              fontSize: 11.sp,
                                              color: ColorStyle.primaryColor,
                                              fontWeight: FontWeight.bold),
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              counterText: '',
                                              hintText: "0",
                                              hintStyle: TextStyle(
                                                  fontSize: 11.sp,
                                                  color:
                                                      ColorStyle.hintDarkColor,
                                                  fontWeight: FontWeight.bold),
                                              labelText: ''),
                                          onChanged: (value) {
                                            if (value.length == 1 &&
                                                index <
                                                    _focusNodes.length - 1) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _focusNodes[index + 1]);
                                            }
                                            if (value.isEmpty && index > 0) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _focusNodes[index - 1]);
                                            }
                                          },
                                        ),
                                      ),
                                    )),
                          ),
                          Spacer(),
                          CustomButton(
                            text: "Verificar código",
                            onTap: () {
                              var code = "";
                              _controllers.forEach((e) {
                                if (e.text != "") {
                                  code += e.text;
                                }
                              });

                              if (code.length == 4) {
                                KidsController.validarCode(code: code)
                                    .then((value) {
                                  context.pop();
                                  _controllers.forEach((e) {
                                    e.text = "";
                                  });

                                  // ignore: unused_result
                                  ref.refresh(getKidsProvider(prefs.usuarioID));
                                });
                              } else {
                                NotificationUI.instance
                                    .notificationWarning("Escribe el código");
                              }
                            },
                            loading: false,
                            textColor: Colors.white,
                            color: ColorStyle.secondaryColor,
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          SizedBox(
                            height: 60,
                          ),
                        ],
                      ),
                    );
                  });
                },
              );
            },
            loading: false,
            textColor: Colors.white,
            color: ColorStyle.primaryColor,
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  Future<void> refresKids(WidgetRef ref) async {
    // ignore: unused_result
    ref.refresh(getKidsProvider(prefs.usuarioID));
  }
}

class KidLinkWidget extends StatelessWidget {
  final Kid kid;
  WidgetRef ref;
  KidLinkWidget({super.key, required this.kid, required this.ref});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(updateKidProvider.notifier).update((state) => true);

        context.pushNamed('kidsAdd',
            pathParameters: {'type': 'edit'}, extra: kid);
      },
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${kid.nombre} ${kid.aPaterno} ${kid.aMaterno}',
                    style: TxtStyle.labelText,
                  ),
                  Row(
                    children: [
                      Text(
                        '${kid.sexo} ',
                        style: TxtStyle.hintText,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      (kid.imtutor != null && kid.imtutor!)
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorStyle.thirdColor),
                              child: Text(
                                "Tutor",
                                style: TxtStyle.hintText
                                    .copyWith(color: Colors.white),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded)
            ],
          )),
    );
  }
}
