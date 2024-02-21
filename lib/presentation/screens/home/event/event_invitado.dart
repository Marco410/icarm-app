import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';

class EventInviteScreen extends ConsumerStatefulWidget {
  final String encontradoID;
  const EventInviteScreen({super.key, required this.encontradoID});

  @override
  ConsumerState<EventInviteScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventInviteScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool loadingInterested = false;

  @override
  Widget build(BuildContext context) {
    final encontrado = ref.watch(getEncontradoProvider(widget.encontradoID));

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        margin: EdgeInsets.only(top: 0, bottom: 10),
        child: SingleChildScrollView(
            child: encontrado.when(
          data: (data) {
            if (data == null) {
              return LoadingStandardWidget.loadingNoDataWidget("encontrado");
            }
            final qrData = "AYR${data.id}";

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Muestra este código para entrar al evento.",
                    style: TxtStyle.headerStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250,
                      backgroundColor: Colors.white,
                      embeddedImageStyle: QrEmbeddedImageStyle(
                          color: Colors.black, size: Size(60, 40)),
                      constrainErrorBounds: true,
                      // ignore: deprecated_member_use
                      foregroundColor: ColorStyle.primaryColor,
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${data.nombre}',
                        style: TxtStyle.headerStyle,
                      ),
                      Text(
                        "${data.aPaterno} ${data.aMaterno}",
                        style: TxtStyle.headerStyle,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        qrData,
                        style: TxtStyle.hintText,
                      ),
                      LineWidget(),
                      ShowDataWidget(
                        title: "Email: ",
                        data: data.email,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Edad: ",
                        data: data.edad,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Género: ",
                        data: data.genero,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Estado civil: ",
                        data: data.estadoCivil,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Teléfono: ",
                        data: data.telefono,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Nombre familiar: ",
                        data: data.refNombre,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ShowDataWidget(
                        title: "Teléfono familiar: ",
                        data: data.refTelefono,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) =>
              Center(child: LoadingStandardWidget.loadingErrorWidget()),
          loading: () => Container(
              height: 80.h, child: LoadingStandardWidget.loadingWidget()),
        )),
      ),
    );
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TxtStyle.labelText,
        ),
        Text(
          data,
          style: TxtStyle.labelText.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
