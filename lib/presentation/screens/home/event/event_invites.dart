import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:sizer_pro/sizer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';

class EventInvitesScreen extends ConsumerStatefulWidget {
  final String eventoID;
  const EventInvitesScreen({super.key, required this.eventoID});

  @override
  ConsumerState<EventInvitesScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventInvitesScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool loadingInterested = false;

  @override
  Widget build(BuildContext context) {
    final evento = ref.watch(getEventoProvider(widget.eventoID));
    final invitadosList = ref.watch(getInvitadosProvider(widget.eventoID));

    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 0, bottom: 10),
        child: SingleChildScrollView(
            child: evento.when(
          data: (data) {
            if (data == null) {
              return LoadingStandardWidget.loadingNoDataWidget("evento");
            }

            return Column(
              children: [
                (data.imgHorizontal != null)
                    ? CachedNetworkImage(
                        imageUrl:
                            "${URL_MEDIA_EVENTO}/${data.id}/${data.imgHorizontal}",
                        placeholder: (context, url) =>
                            LoadingStandardWidget.loadingWidget(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                        height: 30.h,
                        width: double.infinity,
                      )
                    : Image.asset("assets/image/no-image.png",
                        height: 30.h, width: double.infinity, scale: 4.5),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        data.nombre,
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(fontSize: 9.sp),
                      ),
                      Text(
                        "Tus Invitados",
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(
                            fontSize: 7.sp, color: ColorStyle.secondaryColor),
                      ),
                      LineWidget(),
                      SizedBox(
                        height: 15,
                      ),
                      invitadosList.when(
                        data: (invitados) {
                          if (invitados.isEmpty) {
                            return LoadingStandardWidget.loadingNoDataWidget(
                                "invitados");
                          }

                          return Container(
                            child: ListView.builder(
                              itemCount: invitados.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => InkWell(
                                onTap: () => context.pushNamed('event.invitado',
                                    pathParameters: {
                                      'encontradoID':
                                          invitados[index].id.toString(),
                                      'eventoID': widget.eventoID
                                    }),
                                child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: ColorStyle.hintDarkColor,
                                            width: 0.2),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${invitados[index].nombre} ${invitados[index].aPaterno} ${invitados[index].aMaterno}",
                                              style:
                                                  TxtStyle.labelText.copyWith(
                                                fontSize: 6.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            (invitados[index]
                                                        .userId
                                                        .toString() ==
                                                    prefs.usuarioID)
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: ColorStyle
                                                            .secondaryColor),
                                                    child: Text(
                                                      "Tú",
                                                      style: TxtStyle.labelText
                                                          .copyWith(
                                                              fontSize: 4.sp,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios_rounded)
                                      ],
                                    )),
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Center(
                            child: LoadingStandardWidget.loadingErrorWidget()),
                        loading: () => Center(
                            child: LoadingStandardWidget.loadingWidget()),
                      ),
                      CustomButton(
                          text: "Regresar",
                          onTap: () => context.pop(),
                          color: ColorStyle.secondaryColor,
                          textColor: Colors.white,
                          loading: false)
                    ],
                  ),
                )
              ],
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
