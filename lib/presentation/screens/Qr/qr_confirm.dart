// ignore_for_file: must_be_immutable, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/zcomponents.dart';
import 'package:icarm/presentation/models/paselista/paseListaModels.dart';

import '../../providers/pase_lista_service.dart';

class QRConfirm extends ConsumerStatefulWidget {
  QRConfirm();

  _QRConfirmState createState() => _QRConfirmState();
}

class _QRConfirmState extends ConsumerState<QRConfirm> {
  _QRConfirmState();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final userScanned = ref.watch(userNameScannedProvider);
    final userIDScanned = ref.watch(userIDScannedProvider);
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
            Icon(
              Icons.face_rounded,
              size: 50,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Pase de lista para:",
              style:
                  TxtStyle.headerStyle.copyWith(fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '${userScanned}',
                    textAlign: TextAlign.center,
                    style: TxtStyle.headerStyle.copyWith(fontSize: 30),
                  ),
                ),
              ],
            ),
            (userIDScanned != 0)
                ? CustomButton(
                    text: "Confirmar",
                    onTap: () {
                      ref.refresh(addPaseListaProvider(PaseListaData(
                          context: context,
                          user_id: userIDScanned.toString())));
                    },
                    loading: false,
                    textColor: Colors.white,
                    margin: EdgeInsets.only(top: 40),
                    color: ColorStyle.secondaryColor,
                  )
                : SizedBox(),
            CustomButton(
              text: "Cancelar",
              onTap: () => context.pushReplacementNamed('scanner',
                  pathParameters: {"type": "pase_lista"}),
              loading: false,
              color: ColorStyle.hintDarkColor,
              textColor: Colors.white,
              margin: EdgeInsets.only(top: 10),
            ),
          ],
        ),
      ),
    );
  }
}
