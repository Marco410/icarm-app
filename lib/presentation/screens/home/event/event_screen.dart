import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/presentation/components/drawer.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/controllers/evento_controller.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';

class EventScreen extends ConsumerStatefulWidget {
  final String eventoID;
  const EventScreen({super.key, required this.eventoID});

  @override
  ConsumerState<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  List<Calendar> _calendars = [];
  List<Calendar> get _writableCalendars =>
      _calendars.where((c) => c.isReadOnly == false).toList();

  List<Calendar> get _readOnlyCalendars =>
      _calendars.where((c) => c.isReadOnly == true).toList();

  @override
  void initState() {
    super.initState();
  }

  bool loadingInterested = false;

  @override
  Widget build(BuildContext context) {
    final evento = ref.watch(getEventoProvider(widget.eventoID));
    final isUserInterested = ref.watch(isUSerInterestedProvider);

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
                            "${URL_MEDIA_EVENTO}${data.id}/${data.imgHorizontal}",
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
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        data.nombre,
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(fontSize: 9.sp),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      (prefs.usuarioID != "")
                          ? (loadingInterested)
                              ? LoadingStandardWidget.loadingWidget()
                              : InkWell(
                                  onTap: () async {
                                    setState(() => loadingInterested = true);
                                    await EventoController.createInterest(
                                            eventoID: widget.eventoID,
                                            usuarioID: prefs.usuarioID)
                                        .then((value) {
                                      // ignore: unused_result
                                      ref.refresh(
                                          getEventoProvider(widget.eventoID));

                                      Future.delayed(Duration(seconds: 1), () {
                                        setState(
                                            () => loadingInterested = false);
                                      });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: (isUserInterested)
                                            ? ColorStyle.secondaryColor
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            (isUserInterested)
                                                ? Icons.star
                                                : Icons.star_outline,
                                            color: ColorStyle.whiteBacground,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Interesado",
                                            style: TxtStyle.labelText.copyWith(
                                                color:
                                                    ColorStyle.whiteBacground),
                                          ),
                                        ]),
                                  ),
                                )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      (data.interestedCount != 0)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Personas interesadas: ",
                                  style: TxtStyle.labelText,
                                ),
                                Text(
                                  "${data.interestedCount}",
                                  style: TxtStyle.labelText.copyWith(
                                      color: ColorStyle.secondaryColor),
                                ),
                              ],
                            )
                          : SizedBox(),
                      LineWidget(),
                      Text(
                        "Fecha, hora y ubicación",
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(fontSize: 7.sp),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Inicio: ",
                            style: TxtStyle.labelText
                                .copyWith(color: ColorStyle.secondaryColor),
                          ),
                          Text(
                            DateFormat('dd MMMM HH:mm')
                                    .format(data.fechaInicio) +
                                " hrs",
                            textAlign: TextAlign.center,
                            style: TxtStyle.labelText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fin: ",
                            style: TxtStyle.labelText
                                .copyWith(color: ColorStyle.secondaryColor),
                          ),
                          Text(
                            DateFormat('dd MMMM HH:mm').format(data.fechaFin) +
                                " hrs",
                            textAlign: TextAlign.center,
                            style: TxtStyle.labelText,
                          ),
                        ],
                      ),
                      /* SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          /*    var createEventResult = await _deviceCalendarPlugin
                              .createOrUpdateEvent(_event);
                          if (createEventResult?.isSuccess == true) {
                            Navigator.pop(context, true);
                          } else {
                            print(createEventResult?.errors
                                .map((err) =>
                                    '[${err.errorCode}] ${err.errorMessage}')
                                .join(' | ') as String);
                          } */
                          var result =
                              await _deviceCalendarPlugin.createCalendar(
                            _calendarName,
                            calendarColor: ColorStyle.secondaryColor,
                            localAccountName: _localAccountName,
                          );

                          if (result.isSuccess) {
                            Navigator.pop(context, true);
                          } else {
                            if (await Permission.contacts.request().isDenied) {
                              await Permission.contacts.request();
                              await Permission.calendarFullAccess.request();
                              // Either the permission was already granted before or the user just granted it.
                            }
                            print(result.errors
                                .map((err) =>
                                    '[${err.errorCode}] ${err.errorMessage}')
                                .join(' | '));
                          }
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                          decoration: BoxDecoration(
                              color: ColorStyle.primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "Añadir al calendario",
                            style: TxtStyle.labelText.copyWith(
                                color: Colors.white, fontSize: 4.5.sp),
                          ),
                        ),
                      ), */
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          String searchString = (data.direccion == null)
                              ? "${data.iglesia.calle} #${data.iglesia.numero} ${data.iglesia.colonia}, ${data.iglesia.ciudad}, ${data.iglesia.estado}, ${data.iglesia.pais}."
                              : data.direccion;

                          final Uri toLaunch = Uri(
                            scheme: 'https',
                            host: 'google.com',
                            path: 'maps/search/$searchString',
                          );

                          launchUrl(toLaunch,
                              mode: LaunchMode.externalApplication);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pin_drop_rounded,
                                  size: 6.sp,
                                  color: ColorStyle.secondaryColor,
                                ),
                                Text(
                                  "Ubicación",
                                  style: TxtStyle.labelText.copyWith(
                                      color: ColorStyle.secondaryColor),
                                ),
                              ],
                            ),
                            (data.direccion == null)
                                ? Text(
                                    "${data.iglesia.calle} #${data.iglesia.numero} ${data.iglesia.colonia}, ${data.iglesia.ciudad}, ${data.iglesia.estado}, ${data.iglesia.pais}.",
                                    textAlign: TextAlign.center,
                                    style: TxtStyle.labelText,
                                  )
                                : Text(
                                    data.direccion,
                                    textAlign: TextAlign.center,
                                    style: TxtStyle.labelText,
                                  ),
                            SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                String searchString = (data.direccion == null)
                                    ? "${data.iglesia.calle} #${data.iglesia.numero} ${data.iglesia.colonia}, ${data.iglesia.ciudad}, ${data.iglesia.estado}, ${data.iglesia.pais}."
                                    : data.direccion;

                                final Uri toLaunch = Uri(
                                  scheme: 'https',
                                  host: 'google.com',
                                  path: 'maps/search/$searchString',
                                );

                                launchUrl(toLaunch,
                                    mode: LaunchMode.externalApplication);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 25),
                                decoration: BoxDecoration(
                                    color: ColorStyle.primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "Abrir mapa",
                                  style: TxtStyle.labelText.copyWith(
                                      color: Colors.white, fontSize: 4.5.sp),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      /*   Text(
                      widget.event.direccion,
                      textAlign: TextAlign.center,
                      style: TxtStyle.hintText,
                    ), */
                      LineWidget(),
                      Text(
                        "Acerca del evento",
                        textAlign: TextAlign.center,
                        style: TxtStyle.headerStyle.copyWith(fontSize: 7.sp),
                      ),
                      LineWidget(),
                      Html(
                        data: data.descripcion,
                      ),
                      (data.canRegister == 1 && prefs.usuarioID != "")
                          ? Column(
                              children: [
                                LineWidget(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomButton(
                                          text: "A ti mismo",
                                          onTap: () => context.pushNamed(
                                                  'event.register',
                                                  pathParameters: {
                                                    "eventoID": widget.eventoID,
                                                    "type": 'create',
                                                    "toRegister": "self"
                                                  }),
                                          margin: EdgeInsets.all(2),
                                          size: 'sm',
                                          color: Colors.white,
                                          loading: false),
                                    ),
                                    Expanded(
                                      child: CustomButton(
                                          text: "A otra persona",
                                          onTap: () => context.pushNamed(
                                                  'event.register',
                                                  pathParameters: {
                                                    "eventoID": widget.eventoID,
                                                    "type": 'create',
                                                    "toRegister": "guess"
                                                  }),
                                          margin: EdgeInsets.all(2),
                                          size: 'sm',
                                          color: ColorStyle.secondaryColor,
                                          textColor: Colors.white,
                                          loading: false),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CustomButton(
                                    text: "Abrir mi lista de invitados",
                                    onTap: () => context.pushNamed(
                                            'event.invites',
                                            pathParameters: {
                                              'eventoID': widget.eventoID
                                            }),
                                    margin: EdgeInsets.all(2),
                                    size: 'sm',
                                    color: ColorStyle.primaryColor,
                                    textColor: Colors.white,
                                    loading: false)
                              ],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                ),
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
