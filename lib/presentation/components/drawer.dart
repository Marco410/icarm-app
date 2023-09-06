import 'package:accordion/accordion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import '../../config/share_prefs/prefs_usuario.dart';

class MaterialDrawer extends StatefulWidget {
  final String currentPage;

  const MaterialDrawer({super.key, required this.currentPage});

  @override
  State<MaterialDrawer> createState() => _MaterialDrawerState();
}

class _MaterialDrawerState extends State<MaterialDrawer> {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    int eventSelected = 0;

    List<Event> events = [
      Event(
          title: "Retiro de Transformación",
          text: "29, 30 de Septiembre y 1 de Octubre",
          image: 'retiro.jpg'),
      Event(
        title: "Aniversario",
        text: "8, 9 y 10 de Noviembre",
        image: 'podcast.png',
      )
    ];

    return Drawer(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                margin: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () => context.pop(),
                        child: Icon(Icons.arrow_back_ios)),
                    Image.asset(
                      "assets/image/logo.png",
                      scale: 150,
                    ),
                    SvgPicture.asset("assets/icon/user-icon.svg"),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Accordion(
                contentHorizontalPadding: 10,
                contentVerticalPadding: 10,
                headerPadding:
                    EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                contentBorderWidth: 0.5,
                headerBorderColor: ColorStyle.primaryColor.withOpacity(0.3),
                headerBorderWidth: 0.5,
                headerBackgroundColor: Colors.white,
                contentBorderColor: ColorStyle.primaryColor.withOpacity(0.3),
                rightIcon: Icon(
                  Icons.keyboard_arrow_down,
                  size: 34,
                ),
                children: [
                  AccordionSection(
                    isOpen: true,
                    header: HeaderTextWidget(
                      title: "Eventos",
                      text: "Conoce nuestros próximos eventos",
                    ),
                    content: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: events.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SubAccordionWidget(
                                active: eventSelected == index,
                                onTap: () {
                                  setState(() {
                                    eventSelected = index;
                                  });
                                },
                                title: events[index].title,
                                text: events[index].text,
                                image: events[index].image,
                              );
                            })
                      ],
                    ),
                  ),
                  AccordionSection(
                    header: HeaderTextWidget(
                      title: "Online",
                      text: "Accede a nuestros recursos en linea",
                    ),
                    content: const Text(
                      "-",
                    ),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

class SubAccordionWidget extends StatelessWidget {
  final bool active;
  final String title;
  final String text;
  final String image;
  final Function onTap;
  const SubAccordionWidget({
    required this.active,
    required this.title,
    required this.text,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function(),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black54,
              width: 0.3,
            ),
          ),
        ),
        child: Column(
          children: [
            (active)
                ? Image.asset(
                    "assets/image/events/${image}",
                    scale: 1.1,
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderTextWidget(title: title, text: text),
                Icon(
                  (active)
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.keyboard_arrow_down,
                  size: (active) ? 25 : 35,
                )
              ],
            ),
          ],
        ),
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

class Event {
  final String title;
  final String text;
  final String image;

  Event({
    required this.title,
    required this.text,
    required this.image,
  });
}
