import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/accordion_widget.dart';
import 'package:icarm/presentation/components/sub_accordion_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialDrawer extends StatefulWidget {
  const MaterialDrawer({super.key});

  @override
  State<MaterialDrawer> createState() => _MaterialDrawerState();
}

class _MaterialDrawerState extends State<MaterialDrawer> {
  List<bool> links = [false, false, false, false, false, false, false];
  List<Event> events = [
    /* Event(
        title: "16° Aniversario",
        text: "8 al 10 de Noviembre",
        selected: true,
        horario: "",
        direccion: "Puerto de Coatzacoalcos #95, 58337, Morelia Mich.",
        acerca_de:
            "Ven y celebra con nosotros nuestro 16 aniversario \n Miércoles.\nServicio de Apertura \n7:00pm\nJueves\nSeminario para pastores y líderes\n9:00am\nServicio Especial\n7:00pm\nViernes\nSeminario para pastores y líderes\n9:00am\nServicio de Clausura\n7:00pm",
        invitados: [
          Invitado(name: "Pedro y Lety Cantú", image: ""),
          Invitado(name: "Job Gonzalez", image: ""),
          Invitado(name: "Oasis Ministry", image: ""),
        ],
        image: 'events/aniversario.jpg'), */
    /* Event(
        title: "Aniversario",
        text: "8, 9 y 10 de Noviembre",
        image: 'events/retiro.jpg',
        horario: "7:00 pm",
        direccion:
            "Puerto Coatzacoalcos #91 Col. Tinijaro Morelia, Mich. México",
        acerca_de: "",
        selected: false),
    Event(
        title: "Acción de gracias",
        text: "31 de Diciembre",
        image: 'events/retiro.jpg',
        horario: "7:00 pm",
        direccion:
            "Puerto Coatzacoalcos #91 Col. Tinijaro Morelia, Mich. México",
        acerca_de: "",
        selected: false) */
  ];

  List<Online> onlines = [
    Online(
        title: "Cursos",
        text: "Accede a nuestros cursos online",
        selected: true,
        image: 'online/cursos.png'),
    Online(
        title: "Predicas",
        text: "Escucha nuestros mensajes.",
        image: 'online/cursos.png',
        selected: false),
    Online(
        title: "Radio",
        text: "Escucha A&R Radio en vivo",
        image: 'online/cursos.png',
        selected: false)
  ];
  @override
  Widget build(BuildContext context) {
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
              GestureDetector(
                onTap: () => setState(() => links[0] = !links[0]),
                child: AccordionWidget(
                  title: "Eventos",
                  subtitle: "Conoce nuestros próximos eventos",
                  isOpen: links[0],
                  content: (events.length != 0)
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
                                  events[index].selected =
                                      !events[index].selected;
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
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launch(
                    "https://www.amoryrestauracionmorelia.org/online-1") /* setState(() => links[1] = !links[1]) */,
                child: AccordionWidget(
                  title: "Online",
                  subtitle: "Accede a nuestros recursos en linea",
                  isOpen: links[1],
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
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launch(
                    "https://www.amoryrestauracionmorelia.org/refugios-1") /* setState(() => links[3] = !links[3]) */,
                child: AccordionWidget(
                  title: "Refugios",
                  subtitle: "Conoce nuestros centros",
                  isOpen: links[3],
                  content: Text("En construcción"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launch(
                    "https://www.amoryrestauracionmorelia.org/alimentos-1") /* setState(() => links[4] = !links[4]) */,
                child: AccordionWidget(
                  title: "Banco de alimentos",
                  subtitle: "Participa en el próximo",
                  isOpen: links[4],
                  content: Text("En construcción"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launch(
                    "https://www.amoryrestauracionmorelia.org/iglesias-1") /* setState(() => links[5] = !links[5]) */,
                child: AccordionWidget(
                  title: "Más iglesias",
                  subtitle: "Consulta más ubicaciones en México",
                  isOpen: links[5],
                  content: Text("En construcción"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () => launch(
                    "https://www.amoryrestauracionmorelia.org/biblia-1") /* setState(() => links[6] = !links[6]) */,
                child: AccordionWidget(
                  title: "Biblia",
                  subtitle: "Accede a nuestros planes de lectura",
                  isOpen: links[6],
                  content: Text("En construcción"),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      launch(
                          "https://www.facebook.com/AmoryrestauracionmoreliaOficial");
                    },
                    child: Icon(
                      Icons.facebook_rounded,
                      size: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(
                          "https://www.amoryrestauracionmorelia.org/whatsapp-1");
                    },
                    child: Image.network(
                      "https://static.wixstatic.com/media/3d0692_2abf6ec42ad54a56aa2258e118b24306~mv2.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/3d0692_2abf6ec42ad54a56aa2258e118b24306~mv2.png",
                      scale: 3,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(
                          "https://www.youtube.com/channel/UCWiKT0FHEO4wIVJhHJMECWA");
                    },
                    child: Image.network(
                      "https://static.wixstatic.com/media/78aa2057f0cb42fbbaffcbc36280a64a.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/78aa2057f0cb42fbbaffcbc36280a64a.png",
                      scale: 2.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      launch(
                          "https://www.instagram.com/amoryrestauracion_morelia/");
                    },
                    child: Image.network(
                      "https://static.wixstatic.com/media/01c3aff52f2a4dffa526d7a9843d46ea.png/v1/fill/w_104,h_104,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/01c3aff52f2a4dffa526d7a9843d46ea.png",
                      scale: 2.5,
                    ),
                  ),
                ],
              ),
            ],
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

class Event {
  final String title;
  final String text;
  final String horario;
  final String direccion;
  final String image;
  final String acerca_de;
  final List<Invitado> invitados;
  bool selected;

  Event({
    required this.title,
    required this.text,
    required this.image,
    required this.horario,
    required this.selected,
    required this.direccion,
    required this.acerca_de,
    required this.invitados,
  });
}

class Online {
  final String title;
  final String text;
  final String image;
  bool selected;

  Online({
    required this.title,
    required this.text,
    required this.image,
    required this.selected,
  });
}

class Invitado {
  final String name;
  final String image;

  Invitado({
    required this.name,
    required this.image,
  });
}
