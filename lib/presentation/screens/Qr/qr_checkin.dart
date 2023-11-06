// ignore_for_file: unused_result

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/providers/pase_lista_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../components/zcomponents.dart';

class QRScanner extends ConsumerStatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  ConsumerState<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends ConsumerState<QRScanner> {
  Barcode? result;
  String resultCode = "";
  String usuario = "";
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      if (controller != null) {
        controller?.resumeCamera();
      }
    }
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(15))),
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          (result != null)
                              ? (result!.code!.substring(0, 3) == 'AYR')
                                  ? Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Text(
                                        "Redirigiendo...",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(8),
                                      child: Text(
                                        "El código QR no tiene el formato correcto",
                                        style:
                                            TextStyle(color: Colors.red[300]),
                                      ))
                              : Container(
                                  child: Text(
                                      "Acerca tu cámara al código QR para escanear"),
                                ),
                        ],
                      ),
                      (result != null)
                          ? InkWell(
                              onTap: (() {
                                setState(() {
                                  result = null;
                                });
                              }),
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: ColorStyle.hintColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(children: [
                                  Text(
                                    "Limpiar",
                                    style: TextStyle(
                                        color: ColorStyle.primaryColor,
                                        fontSize: 15),
                                  ),
                                ]),
                              ),
                            )
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 230.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: ColorStyle.secondaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        resultCode = result!.code!.substring(5);
      });

      print("result!.code!.substring(0, 3)");
      print(result!.code!.substring(0, 3));

      if (result!.code!.substring(0, 3) == 'AYR') {
        controller.dispose();
        ref.refresh(getUserPaseListaProvider(resultCode));

        context.pushReplacementNamed('confirm');
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Habilita tu cámara')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
