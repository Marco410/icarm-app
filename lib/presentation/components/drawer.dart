// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/const.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/accordion_widget.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:icarm/presentation/providers/evento_provider.dart';
import 'package:intl/intl.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialDrawer extends ConsumerStatefulWidget {
  const MaterialDrawer({super.key});

  @override
  ConsumerState<MaterialDrawer> createState() => _MaterialDrawerState();
}

class _MaterialDrawerState extends ConsumerState<MaterialDrawer> {
  List<bool> links = [false, false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    final listEventos = ref.watch(getEventosProvider("user"));
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
            margin: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Bounceable(
                    onTap: () => context.pop(),
                    child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 35,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: ShadowStyle.boxShadow,
                            borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.arrow_back_rounded))),
                Hero(
                  tag: 'logo',
                  child: ImageIcon(
                    AssetImage("assets/image/logo.png"),
                    color: Colors.black,
                    size: 18.sp,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () {
              context.pushNamed("web.view", pathParameters: {
                "url": "https://www.amoryrestauracionmorelia.org/noticias-1"
              });
            },
            title: "Noticias",
            subtitle: "Accede a nuestros recursos en linea",
            isOpen: links[0],
            content: /*  ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: onlines.length,
                itemBuilder: (BuildContext context, int index) {
                  return SubAccordionWidget(
                    active: onlines[index].selected,
                    onTap: () {
                      setState(() {
                        onlines[index].selected =
                            !onlines[index].selected;
                      });
                    },
                    title: onlines[index].title,
                    text: onlines[index].text,
                    image: onlines[index].image,
                    onTapContent: () {},
                  );
                }) */
                Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
              title: "Eventos",
              subtitle: "Conoce nuestros próximos eventos",
              isOpen: links[1],
              onTap: () => setState(() => links[1] = !links[1]),
              content: listEventos.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Text(
                      "No hay eventos en los siguientes días.",
                      style: TxtStyle.hintText,
                    );
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: ColorStyle.whiteBacground,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(bottom: 4),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: GestureDetector(
                            onTap: () => context.pushNamed('event',
                                pathParameters: {
                                  "eventoID": data[index].id.toString()
                                }),
                            child: Row(
                              children: [
                                (data[index].imgHorizontal != null)
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            "${URL_MEDIA_EVENTO}${data[index].id}/${data[index].imgHorizontal}",
                                        placeholder: (context, url) =>
                                            LoadingStandardWidget
                                                .loadingWidget(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                        height: 15.sp,
                                        width: 25.sp,
                                      )
                                    : Image.asset("assets/image/no-image.png",
                                        height: 15.sp,
                                        width: 25.sp,
                                        scale: 4.5),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[index].nombre,
                                          style: TxtStyle.labelText
                                              .copyWith(fontSize: 5.sp),
                                        ),
                                        Text(
                                          DateFormat('dd MMM').format(
                                                  data[index].fechaInicio) +
                                              "-" +
                                              DateFormat('dd MMM')
                                                  .format(data[index].fechaFin),
                                          style: TxtStyle.labelText.copyWith(
                                              fontSize: 4.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    )),
                                Expanded(
                                    child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 6.sp,
                                ))
                              ],
                            ),
                          ),
                        );
                      });
                },
                error: (error, stackTrace) => Text(""),
                loading: () => LoadingStandardWidget.loadingWidget(),
              ) /* (events.length != 0)
                ? ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SubAccordionWidget(
                        active: events[index].selected,
                        onTap: () {
                          setState(() {
                            events[index].selected = !events[index].selected;
                          });
                        },
                        title: events[index].title,
                        text: events[index].text,
                        image: events[index].image,
                        onTapContent: () {
                          context.pushNamed(
                            "event",
                            extra: events[index],
                          );
                        },
                      );
                    })
                : Text(
                    "No hay eventos en los siguientes días.",
                    style: TxtStyle.hintText,
                  ), */
              ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () => context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/online-1"
            }) /* setState(() => links[1] = !links[1]) */,
            title: "Online",
            subtitle: "Accede a nuestros recursos en linea",
            isOpen: links[2],
            content: /*  ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                itemCount: onlines.length,
                itemBuilder: (BuildContext context, int index) {
                  return SubAccordionWidget(
                    active: onlines[index].selected,
                    onTap: () {
                      setState(() {
                        onlines[index].selected =
                            !onlines[index].selected;
                      });
                    },
                    title: onlines[index].title,
                    text: onlines[index].text,
                    image: onlines[index].image,
                    onTapContent: () {},
                  );
                }) */
                Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () => context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/refugios-1"
            }) /* setState(() => links[3] = !links[3]) */,
            title: "Refugios",
            subtitle: "Conoce nuestros centros",
            isOpen: links[3],
            content: Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () => context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/alimentos-1"
            }) /* setState(() => links[4] = !links[4]) */,
            title: "Banco de alimentos",
            subtitle: "Participa en el próximo",
            isOpen: links[4],
            content: Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () => context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/iglesias-1"
            }) /* setState(() => links[5] = !links[5]) */,
            title: "Más iglesias",
            subtitle: "Consulta más ubicaciones en México",
            isOpen: links[5],
            content: Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () => context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/biblia-1"
            }) /* setState(() => links[6] = !links[6]) */,
            title: "Biblia",
            subtitle: "Accede a nuestros planes de lectura",
            isOpen: links[6],
            content: Text("En construcción"),
          ),
          const SizedBox(
            height: 10,
          ),
          AccordionWidget(
            onTap: () {
              //https://donar.amoryrestauracionmorelia.org/b/9AQ8zW4Fg9xl55CdQQ
              final Uri toLaunch = Uri(
                  scheme: 'https',
                  host: 'donar.amoryrestauracionmorelia.org',
                  path: 'b/9AQ8zW4Fg9xl55CdQQ',
                  queryParameters: {});

              launchUrl(toLaunch, mode: LaunchMode.externalApplication);
            } /* context.pushNamed("web.view", pathParameters: {
              "url": "https://www.amoryrestauracionmorelia.org/donacionapp"
            })  */ /* setState(() => links[6] = !links[6]) */,
            title: "Donaciones",
            subtitle: "Gracias por tu generosidad.",
            isOpen: links[7],
            content: Text("En construcción"),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'facebook.com',
                      path: 'AmoryrestauracionmoreliaOficial',
                      queryParameters: {});

                  launchUrl(toLaunch, mode: LaunchMode.externalApplication);
                },
                child: Icon(
                  Icons.facebook_rounded,
                  size: 30,
                ),
              ),
              InkWell(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'amoryrestauracionmorelia.org',
                      path: 'whatsapp-1',
                      queryParameters: {});

                  launchUrl(toLaunch, mode: LaunchMode.externalApplication);
                },
                child: Image.network(
                  "https://static.wixstatic.com/media/3d0692_2abf6ec42ad54a56aa2258e118b24306~mv2.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/3d0692_2abf6ec42ad54a56aa2258e118b24306~mv2.png",
                  scale: 4,
                ),
              ),
              InkWell(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'youtube.com',
                      path: 'channel/UCWiKT0FHEO4wIVJhHJMECWA',
                      queryParameters: {});

                  launchUrl(toLaunch, mode: LaunchMode.externalApplication);
                },
                child: Image.network(
                  "https://static.wixstatic.com/media/78aa2057f0cb42fbbaffcbc36280a64a.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/78aa2057f0cb42fbbaffcbc36280a64a.png",
                  scale: 3.5,
                ),
              ),
              InkWell(
                onTap: () {
                  final Uri toLaunch = Uri(
                      scheme: 'https',
                      host: 'instagram.com',
                      path: 'amoryrestauracion_morelia',
                      queryParameters: {});

                  launchUrl(toLaunch, mode: LaunchMode.externalApplication);
                },
                child: Image.network(
                  "https://static.wixstatic.com/media/01c3aff52f2a4dffa526d7a9843d46ea.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/01c3aff52f2a4dffa526d7a9843d46ea.png",
                  scale: 3.5,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
        ]),
      ),
    );
  }
}

class HeaderTextWidget extends StatelessWidget {
  final String title;
  final String text;
  const HeaderTextWidget({
    required this.title,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TxtStyle.headerStyle
              .copyWith(color: ColorStyle.primaryColor, fontSize: 17),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: TxtStyle.hintText,
        ),
      ],
    );
  }
}
