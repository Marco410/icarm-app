// ignore_for_file: unused_result

import 'package:flutter/Material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/services/notification_ui_service.dart';
import 'package:icarm/presentation/components/dropdown_widget.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/pase_lista_controller.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:icarm/presentation/providers/pase_lista_service.dart';
import 'package:icarm/presentation/providers/user_provider.dart';
import 'package:icarm/presentation/screens/Qr/qr_confirm.dart';
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
                        onTap: () => context.pushNamed('scanner',
                            pathParameters: {"type": "pase_lista"}),
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
              (userScanned != "")
                  ? CustomButton(
                      text: "Pasar Lista",
                      textColor: Colors.white,
                      onTap: () {
                        if (edit) {
                          NotificationUI.instance
                              .notificationWarning('Termina de editar.');

                          return;
                        }

                        if (userScanned != null) {
                          if (eventoSelected.id == 0) {
                            NotificationUI.instance
                                .notificationWarning('Selecciona un evento.');
                            return;
                          }

                          PaseListaController.addPaseLista(
                                  usuarioID: userScanned.id.toString(),
                                  eventoID: eventoSelected.id.toString())
                              .then((value) {
                            if (value) {
                              NotificationUI.instance.notificationSuccess(
                                  'Pase de lista exitoso.');

                              ref
                                  .read(userScannedProvider.notifier)
                                  .update((state) => null);
                            } else {
                              NotificationUI.instance.notificationWarning(
                                  'No pudimos completar la operación, inténtelo más tarde.');
                            }
                          });

                          /*    ref.refresh(addPaseListaProvider(PaseListaData(
                              context: context,
                              user_id: userScanned.id.toString()))); */
                        } else {
                          NotificationUI.instance
                              .notificationWarning("Selecciona un usuario.");
                        }
                      },
                      loading: false)
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
