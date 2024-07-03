// ignore_for_file: unused_result

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/dropdown_widget.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/components/views/make_payment.dart';
import 'package:icarm/presentation/controllers/pase_lista_controller.dart';
import 'package:icarm/presentation/models/UsuarioModel.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:icarm/presentation/providers/pase_lista_service.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:icarm/presentation/screens/Qr/qr_confirm.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/dropdow_options.dart';
import '../../../components/zcomponents.dart';

class PaseListaPage extends ConsumerStatefulWidget {
  const PaseListaPage({super.key});

  @override
  ConsumerState<PaseListaPage> createState() => _EventosAdminPageState();
}

class _EventosAdminPageState extends ConsumerState<PaseListaPage> {
  Option usuarioSelected = Option(id: 0, name: "Seleccione:");

  @override
  Widget build(BuildContext context) {
    ref.watch(getEventosProvider("admin"));
    ref.watch(getUsersAllProvider);
    ref.watch(getMaestrosListProvider);

    final listEventosOption = ref.watch(eventosOptionsListProvider);
    final eventoSelected = ref.watch(eventoSelectedToPaseLista);
    final usersList = ref.watch(getUserListProvider);
    final userScanned = ref.watch(userScannedProvider);
    final loading = ref.watch(loadingUserScannedProvider);
    final edit = ref.watch(editUserPaseListProvider);

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: (eventoSelected.id == 0)
                          ? DropdownWidget(
                              title: "Evento",
                              option: eventoSelected,
                              isRequired: true,
                              readOnly: false,
                              onTapFunction: () async {
                                final res = await showDropdownOptions(
                                    context,
                                    MediaQuery.of(context).size.height * 0.4,
                                    listEventosOption);

                                if (res != null) {
                                  ref
                                      .read(eventoSelectedToPaseLista.notifier)
                                      .update((state) => res[0] as Option);
                                }
                              })
                          : Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Evento seleccionado:",
                                        style: TxtStyle.hintText.copyWith(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 56.w,
                                        child: Text(
                                          eventoSelected.name,
                                          style: TxtStyle.headerStyle
                                              .copyWith(fontSize: 7.sp),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () => ref
                                        .read(
                                            eventoSelectedToPaseLista.notifier)
                                        .update((state) =>
                                            Option(id: 0, name: "Seleccione:")),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.red[300],
                                    ),
                                  )
                                ],
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () {
                          if (eventoSelected.id == 0) {
                            NotificationUI.instance
                                .notificationWarning("Selecciona un evento.");
                            return;
                          }

                          context.pushNamed('scanner',
                              pathParameters: {"type": "pase_lista"});
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            margin: EdgeInsets.symmetric(
                                vertical: 25, horizontal: 10),
                            decoration: BoxDecoration(
                                color: ColorStyle.secondaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              Icons.qr_code,
                              color: Colors.white,
                              size: 25,
                            ))),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              (eventoSelected.id != 0)
                  ? DropdownWidget(
                      title: "Usuarios",
                      option: usuarioSelected,
                      isRequired: true,
                      readOnly: false,
                      onTapFunction: () async {
                        final res = await showDropdownOptions(
                            context,
                            MediaQuery.of(context).size.height * 0.4,
                            usersList);

                        if (res != null) {
                          ref
                              .read(loadingUserScannedProvider.notifier)
                              .update((state) => true);
                          setState(() {
                            usuarioSelected = res[0] as Option;
                          });

                          ref.refresh(getUserPaseListaProvider(
                              usuarioSelected.id.toString()));
                          ref
                              .read(editUserPaseListProvider.notifier)
                              .update((state) => false);

                          Future.delayed(
                              Duration(seconds: 1),
                              () => setState(() => usuarioSelected =
                                  Option(id: 0, name: "Seleccione: ")));
                        }
                      })
                  : SizedBox(),
              SizedBox(
                height: 16,
              ),
              (loading)
                  ? LoadingStandardWidget.loadingWidget()
                  : (userScanned != null)
                      ? UserScannedWidget(
                          userScanned: userScanned,
                          ref: ref,
                        )
                      : SizedBox(),
              SizedBox(
                height: 16,
              ),
              (userScanned != null && eventoSelected.id != 0)
                  ? CustomButton(
                      text: "Pasar Lista",
                      textColor: Colors.white,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      onTap: () {
                        if (edit) {
                          NotificationUI.instance
                              .notificationWarning('Termina de editar.');

                          return;
                        }

                        if (eventoSelected.id == 0) {
                          NotificationUI.instance
                              .notificationWarning('Selecciona un evento.');
                          return;
                        }

                        PaseListaController.addPaseLista(
                                usuarioID: userScanned.id.toString(),
                                eventoID: eventoSelected.id.toString())
                            .then((value) {
                          ref
                              .read(userScannedProvider.notifier)
                              .update((state) => null);
                        });

                        /*    ref.refresh(addPaseListaProvider(PaseListaData(
                              context: context,
                              user_id: userScanned.id.toString()))); */
                      },
                      loading: false)
                  : SizedBox(),
              (userScanned != null && eventoSelected.id != 0)
                  ? CustomButton(
                      text: "Hacer pago",
                      textColor: Colors.black87,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            title: Text(
                              "Nuevo Pago",
                              style: TxtStyle.headerStyle,
                            ),
                            content: MakePaymentWidget(
                              userID: userScanned.id.toString(),
                              eventoID: eventoSelected.id.toString(),
                              ref: ref,
                            ),
                          ),
                        );
                      },
                      color: ColorStyle.thirdColor,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      loading: false)
                  : SizedBox(),
              (userScanned?.pagos != null && userScanned!.pagos!.length > 0)
                  ? PagosUserWidget(userScanned: userScanned)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

class PagosUserWidget extends StatelessWidget {
  const PagosUserWidget({
    super.key,
    required this.userScanned,
  });

  final User userScanned;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 50),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
              spreadRadius: -3,
              offset: Offset(0, 0))
        ],
      ),
      child: Column(
        children: [
          Text(
            "Pagos",
            style: TxtStyle.headerStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "Concepto",
                  textAlign: TextAlign.center,
                  style: TxtStyle.labelText.copyWith(color: Colors.white),
                )),
                Expanded(
                    child: Text(
                  "Cantidad",
                  textAlign: TextAlign.center,
                  style: TxtStyle.labelText.copyWith(color: Colors.white),
                )),
                Expanded(
                    child: Text(
                  "Fecha",
                  textAlign: TextAlign.center,
                  style: TxtStyle.labelText.copyWith(color: Colors.white),
                )),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 200,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
              shrinkWrap: true,
              itemCount: userScanned.pagos!.length,
              itemBuilder: (context, index) => Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(
                    "${userScanned.pagos![index].concepto}",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "\$${userScanned.pagos![index].cantidad.toDouble()}",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    DateFormat('dd MMMM yyyy')
                        .format(userScanned.pagos![index].created_at),
                    textAlign: TextAlign.center,
                  )),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
