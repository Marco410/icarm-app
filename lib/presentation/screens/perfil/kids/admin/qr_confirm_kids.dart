// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/providers/kids_service.dart';

import '../../../../models/models.dart';
import '../../../../providers/teacher_kids_provider.dart';

class QRConfirmKids extends ConsumerStatefulWidget {
  final String userID;
  QRConfirmKids({required this.userID});

  _QRConfirmKidsState createState() => _QRConfirmKidsState();
}

class _QRConfirmKidsState extends ConsumerState<QRConfirmKids> {
  _QRConfirmKidsState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final kidsList = ref.watch(getKidsProvider(widget.userID));

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                Icons.class_rounded,
                size: 50,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Selecciona un niño:",
                style: TxtStyle.headerStyle
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            kidsList.when(
              data: (data) {
                return Expanded(
                  flex: 10,
                  child: ListView.builder(
                    itemCount: data!.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          ref.refresh(registerKidTeacherProvider(
                              KidRegisterTeacherData(
                                  kid_id: data[index].id.toString(),
                                  context: context)));
                        },
                        child: Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.all(10),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Icon(
                                    (data[index].sexo == 'Hombre')
                                        ? Icons.face_rounded
                                        : Icons.face_2_rounded,
                                    color: ColorStyle.secondaryColor,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Expanded(
                                  flex: 10,
                                  child: Text(
                                    "${data[index].nombre} ${data[index].aPaterno} ${data[index].aMaterno}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child:
                                        Icon(Icons.arrow_forward_ios_rounded))
                              ],
                            )),
                      );
                    },
                  ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return LoadingStandardWidget.loadingErrorWidget();
              },
              loading: () {
                return Center(child: LoadingStandardWidget.loadingWidget());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [],
            ),
            CustomButton(
              text: "Cancelar",
              onTap: () => context.pushReplacementNamed('scanner',
                  pathParameters: {"type": "kids"}),
              loading: false,
              color: ColorStyle.hintDarkColor,
              textColor: Colors.white,
              margin: EdgeInsets.only(top: 10),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
