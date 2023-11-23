// ignore_for_file: must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/config/share_prefs/prefs_usuario.dart';
import 'package:icarm/presentation/components/loading_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BetelesPage extends StatefulWidget {
  const BetelesPage({
    Key? key,
  }) : super(key: key);
  @override
  State<BetelesPage> createState() => _BetelesPageState();
}

class _BetelesPageState extends State<BetelesPage> {
  List<Betel> betelesList = [
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_8141d29726e84eed879e04cf01ac56b6~mv2.jpg/v1/fill/w_322,h_324,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Boris.jpg",
      first_name: "Boris Ibarra Rojas",
      second_name: "Mayra Alejandra Padilla",
      anf_first_name: "Benjamín Miranda Cervantes",
      anf_second_name: "Maria del Rocio Espinoza Castellón",
      direccion_first: "Av. Ocampo #647",
      direccion_second: "Col. Felícitas del Rio Morelia",
      phone: "4431325773",
      mapUrl:
          "https://www.google.com/maps?q=Ocampo+647,+Fel%C3%ADcitas+del+R%C3%ADo,+58040+Morelia,+Mich.&ftid=0x842d0dd794e3deb1:0xcf9c18c1fa456ebe",
      contacto: "4431325773 | 4434118148",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_f780f95cdf3e4739804804a8bb0306aa~mv2.jpg/v1/fill/w_322,h_324,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/IMG_9955.jpg",
      first_name: "Jose Mariano Paniagua Contreras",
      second_name: "Sara Briyee Aguilar Rodriguez",
      anf_first_name: "Antonio Luis Serrano Chávez",
      anf_second_name: "Celia Durán",
      direccion_first: "Republicano Patzcuarence #304",
      direccion_second: "Col. Manuel García Pueblita",
      phone: "4436280013",
      mapUrl:
          "https://www.google.com/maps?q=Republicano+Patzcuarence+304,+Manuel+Garc%C3%ADa+Pueblita,+58337+Morelia,+Mich.&ftid=0x842d0950783bcac7:0xf4196945f40c9694",
      contacto: "4436280013",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_21f34a70e59644adb429b475c99c1d33~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Edgar.jpg",
      first_name: "Edgar Miguel Gonzalez Ponce",
      second_name: "",
      anf_first_name: "Eduardo Medina Cruz",
      anf_second_name: "Fabiola Luna Chavez",
      direccion_first: "Manuel Romero Rubio #119",
      direccion_second: "Col. José María Morelos",
      phone: "4432536845",
      mapUrl:
          "https://www.google.com/maps?q=Manuel+Romero+Rubio+119,+Jos%C3%A9+Mar%C3%ADa+Morelos,+58148+Morelia,+Mich.&ftid=0x842d0e8d48a70db3:0x95273a8f128163ec",
      contacto: "4432536845",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_4c0d68ddb92743008e6de35ae1dc9814~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Gustavo.jpg",
      first_name: "Gustavo Rendon Solorio",
      second_name: "Erendira Mora Santoyo",
      anf_first_name: "Crispin Luna Maldonado",
      anf_second_name: "Adriana Barajas Villa",
      direccion_first: "Puruaran #176",
      direccion_second: "Col. 22 de octubre Tenencia Morelos",
      phone: "4432184091",
      mapUrl:
          "https://maps.google.com/?q=Puruar%C3%A1n+176,+22+de+Octubre,+58341+Morelos,+Mich.&ftid=0x842d0c61ad70ef59:0xdc1a2f7d219aec5a",
      contacto: "4432184091 | 4434912655",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_7f94a8997f7d4481b43feb513bdf3cac~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Hector.jpg",
      first_name: "Hector Perez Ambríz",
      second_name: "Ma del Pilar Albor Zetina",
      anf_first_name: "Bruce Ricardo Mota Lagunes",
      anf_second_name: "Claudia Erandi Nuñez Nares",
      direccion_first: "Luis Jurado #658",
      direccion_second: "Col. Defensores de Puebla",
      phone: "4432812023",
      mapUrl:
          "https://maps.google.com/?q=Puruar%C3%A1n+176,+22+de+Octubre,+58341+Morelos,+Mich.&ftid=0x842d0c61ad70ef59:0xdc1a2f7d219aec5a",
      contacto: "4432812023 | 4432731589",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_39393317d15a4ec3a88ed33a2c5df619~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Hector%20y%20Gaby.jpg",
      first_name: "Hector Vallejo Santiago",
      second_name: "Gabriela Meza Chavez",
      anf_first_name: "Maria Guadalupe Martinez Peréz",
      anf_second_name: "",
      direccion_first: "Chalmita #211",
      direccion_second: "Col. Lucio Cabaña",
      phone: "4431032203",
      mapUrl:
          "https://maps.google.com/?q=Chalmita+211,+Veintis%C3%A9is+de+Julio,+58147+Morelia,+Mich.&ftid=0x842d0eb57889aab7:0xaba6eb1cf7ae51da",
      contacto: "4431032203 | 4431580674",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_a4414c436a2e43cea7987651fcff97e8~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Nacho.jpg",
      first_name: "Ignacio Chavez Hernández",
      second_name: "Melania Rodriguez",
      anf_first_name: "Alejandro Neria Hernández",
      anf_second_name: "Marycruz Cazarez",
      direccion_first: "Juan Guillermo Villa sana #166",
      direccion_second: "Col. Jardines de Guadalupe",
      phone: "4432578222",
      mapUrl:
          "https://maps.google.com/?q=C.+Juan+Guillermo+Villasana+166,+Jardines+de+Guadalupe,+58140+Morelia,+Mich.&ftid=0x842d0e95bb423c0b:0xb009987bcf7ac9f2",
      contacto: "4432578222",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_a4800db4b84a4d66a90c9d7400d79965~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Imazul.jpg",
      first_name: "Imazul Espinoza Moreno",
      second_name: "",
      anf_first_name: "Azucena Aguirre Garcia",
      anf_second_name: "",
      direccion_first: "Paracuaro #200",
      direccion_second: "Villa Magna",
      phone: "4433071692",
      mapUrl:
          "https://maps.google.com/?q=Villa+de+Par%C3%A1cuaro,+58330+Villa+Magna,+Mich.&ftid=0x842d0a19c887707d:0x2a6c0f9c857c0271",
      contacto: "4433071692",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/3d0692_84231980f01246a6ba51dbc8ca9c1fc0~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Alberto.jpg",
      first_name: "José Alberto Rios Navarro",
      second_name: "Sugey Espinoza Juarez",
      anf_first_name: "Luis Fernando Hernández Villanueva",
      anf_second_name: "María del Carmen García Cervantes",
      direccion_first: "Omicuaro #83",
      direccion_second: "Fracc. San Isidro Itzicuaro",
      phone: "4434680441",
      mapUrl:
          "https://maps.google.com/?q=Omicuaro+83,+San+Isidro+Itz%C3%ADcuaro,+58337+Morelia,+Mich.&ftid=0x842d09457b4fa0fd:0x19300aea2b7926f4",
      contacto: "4434680441 | 4435679998",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_0b3698ed5f5847cb8c5d5f1652b104b6~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Moreno.jpg",
      first_name: "José Moreno Claro",
      second_name: "Marisela Villa Rangel",
      anf_first_name: "José Aguilar Ramirez",
      anf_second_name: "Mireya Corona Rodríguez",
      direccion_first: "De la Jadeita #197",
      direccion_second: "Villas del Pedregal",
      phone: "4411391218",
      mapUrl:
          "https://maps.google.com/?q=De+la+Jadeita,+58330+Villas+del+Pedregal,+Mich.&ftid=0x842d0a258f4cd807:0x9dcb48d4333c6496",
      contacto: "4411391218 | 4431837775",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_8d8fbbddeec94f46af611950c6219105~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Juan.jpg",
      first_name: "Juan Ignacio Sereno Bejar",
      second_name: "Alejandra Avila Hurtado",
      anf_first_name: "Lindsay Guerrero",
      anf_second_name: "",
      direccion_first: "Juan de Alvarado #50",
      direccion_second: "Nueva Valladolid",
      phone: "4433925062",
      mapUrl:
          "https://maps.google.com/?q=Juan+de+Alvarado+50,+Nueva+Valladolid,+58190+Morelia,+Mich.&ftid=0x842d0e86640e5a51:0x901375d4865ffa2",
      contacto: "4433925062 | 4433935042",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_9fe16c78596745d58017dd68ec84f4d0~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Polo.jpg",
      first_name: "Leopoldo Alfaro Granados",
      second_name: "Guadalupe Rojas Espinoza",
      anf_first_name: "Ismael Diaz Jimenez",
      anf_second_name: "Susana de Jesús Rámirez",
      direccion_first: "Miguel Fernández Felix #446",
      direccion_second: "Col. Guadalupe Victoria",
      phone: "4432177960",
      mapUrl:
          "https://maps.google.com/?q=Miguel+Fern%C3%A1ndez+F%C3%A9lix+446,+Guadalupe+Victoria,+58337+Morelia,+Mich.&ftid=0x842d097b6ab09d01:0x92ced5de3f5e87ba",
      contacto: "4432177960 | 4431996563",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_5a8f8c0c4d934c3fbc38bc5e1d692e6f~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Luis.jpg",
      first_name: "Luis Esquivel Escobar",
      second_name: "Martha Elena Alonso Saucedo",
      anf_first_name: "Adrian Orozco Ortega",
      anf_second_name: "Maria Luisa Rangel Hernández",
      direccion_first: "Andromeda Norte #132",
      direccion_second: "Galaxia Tarimbaro",
      phone: "4433976199",
      mapUrl:
          "https://maps.google.com/?q=Andromeda+132,+Galaxia+Tar%C3%ADmbaro,+58880+Mich.&ftid=0x842d0f98077d9905:0x14a45f61a8964c44",
      contacto: "4433976199 | 4434921530",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_79dc367f167246f6a2194121a6603585~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Noe.jpg",
      first_name: "Noe González Miranda",
      second_name: "Liliana Ayala González",
      anf_first_name: "Cesar Santo Rangel",
      anf_second_name: "Perla de la Luz Pulido Molina",
      direccion_first: "Santa Ines #221",
      direccion_second: "Col. Ciudad Jardín",
      phone: "4433781724",
      mapUrl: "https://maps.google.com/?cid=12518838991975760472",
      contacto: "4433781724 | 4432151501",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_40e1ed2589234acebbce3589e6e40831~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Rene.jpg",
      first_name: "Rene Vargas Sauno",
      second_name: "Alejandra Estrada Rojas",
      anf_first_name: "María del Pilar Delgadillo Piña",
      anf_second_name: "",
      direccion_first: "Lic. Fernando Mártinez #54",
      direccion_second: "Fracc. Ario 1815",
      phone: "4436249234",
      mapUrl:
          "https://maps.google.com/?q=Lic.+Fernando+Mart%C3%ADnez+54,+Ario+1815,+58337+Morelia,+Mich.&ftid=0x842d0967d1bedb7f:0xd41ca6973c322186",
      contacto: "4436249234 | 4432454069",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_77f0b18df51c4b478b213b14976b5d78~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Rocio.jpg",
      first_name: "Rocio Montoya Hernández",
      second_name: "",
      anf_first_name: "Cleotilde Marquéz Olmos",
      anf_second_name: "",
      direccion_first: "Despertador de Michoacán #104",
      direccion_second: "Fracc. Real Santa Rita",
      phone: "4433991290",
      mapUrl: "https://maps.google.com/?cid=5749871865511951740",
      contacto: "4433991290",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_b5c2f8642c4641b29c09981166848910~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Ulises.jpg",
      first_name: "Ulises Baltazar",
      second_name: "",
      anf_first_name: "José Luis Lara Llanos",
      anf_second_name: "Berenice Aicel Serafín Esquivel",
      direccion_first: "Arko San Antonio Retorno Arcillos #36",
      direccion_second: "Morelia",
      phone: "4431302711",
      mapUrl: "https://maps.google.com/?cid=1627554501286127137",
      contacto: "4431302711",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_de140b93270548cbb171ef4f206a89b1~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Luis%20Cevallos.jpg",
      first_name: "Luis Jesús Gutierrez Ceballos",
      second_name: "Gabriela Cabezas Ríos",
      anf_first_name: "Luis Javier Becerril Mena",
      anf_second_name: "Britney Samantha Barrera Hernández",
      direccion_first: "Av. Valle de Tarímbaro Sin Número",
      direccion_second: "Uruetaro CP: 58891",
      phone: "4432213875",
      mapUrl:
          "https://maps.google.com/?q=Valle+de+Tar%C3%ADmbaro,+58891+Uru%C3%A9taro,+Mich.&ftid=0x842d1a0790cc2635:0x6cd9c5eef933a841",
      contacto: "4432213875 | 4434041980",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/3d0692_fce3d835a937439fbb16ca37e8a8466d~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Retoque%20de%20fotos%20Bethel.jpg",
      first_name: "Juan Ríos García",
      second_name: "Angélica María Almanza Reyes",
      anf_first_name: "-",
      anf_second_name: "",
      direccion_first: "Cerro del Cacique #317",
      direccion_second: "Col. Lomas del Tecnológico",
      phone: "4431212864",
      mapUrl:
          "https://maps.google.com/?q=And.+Cerro+del+Cacique+317,+Lomas+del+Tecnol%C3%B3gico,+58117+Morelia,+Mich.&ftid=0x842d0e5cb67ad257:0xd067a7e3739014a7",
      contacto: "4431212864 | 4432632539",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_46fca63e5c944844a54f6a1a48e34cb0~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/IMG_4026.jpg",
      first_name: "Daniel Bautista Gutierrez",
      second_name: "",
      anf_first_name: "-",
      anf_second_name: "",
      direccion_first: "Junta de Jaujilla #530",
      direccion_second: "Col. Jaujilla",
      phone: "4433767648",
      mapUrl:
          "https://maps.google.com/?q=C.+Junta+de+Jaujilla+530,+Jaujilla,+58179+Morelia,+Mich.&ftid=0x842d0ea06d72ee93:0xa5970c3fcb51e2d5",
      contacto: "4433767648",
    ),
    Betel(
      img:
          "https://static.wixstatic.com/media/bf53c1_57359ee70621402e8ec2cb6a053cdffe~mv2.jpg/v1/fill/w_308,h_308,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/IMG_0099-2_edited.jpg",
      first_name: "Gerardo Vazquez Guido",
      second_name: "Karla Juarez Alanis",
      anf_first_name: "-",
      anf_second_name: "",
      direccion_first: "Abolición de la Esclavitud #131",
      direccion_second: "Col. Independencia",
      phone: "4432266091",
      mapUrl:
          "https://maps.google.com/?q=Abolici%C3%B3n+de+La+Esclavitud+131,+Independencia,+58210+Morelia,+Mich.&ftid=0x842d0e1146c7455b:0x2659f6fd4b0e2bf3",
      contacto: "4432266091 | 4431330511",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 20, right: 20),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Text(
                      "${prefs.nombre} encuentra un betel",
                      overflow: TextOverflow.fade,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Un betel es un grupo pequeño donde cada semana compartimos un tiempo en familia y compartimos la palabra de Dios.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 16,
                child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: betelesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return BetelWidget(betelesList[index]);
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BetelWidget extends StatefulWidget {
  Betel betel;
  BetelWidget(this.betel, {super.key});

  @override
  State<BetelWidget> createState() => _BetelWidgetState();
}

class _BetelWidgetState extends State<BetelWidget> {
  @override
  Widget build(BuildContext context) {
    return FadedScaleAnimation(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showMyDialog(widget.betel);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: /* Image.network(
                  widget.betel.img,
                  scale: 2,
                ) */
                    CachedNetworkImage(
                  imageUrl: widget.betel.img,
                  placeholder: (context, url) =>
                      LoadingStandardWidget.loadingWidget(),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fitWidth),
                    ),
                  ),
                  height: 150,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    (widget.betel.second_name.isNotEmpty)
                        ? widget.betel.first_name +
                            " &\n" +
                            widget.betel.second_name
                        : widget.betel.first_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: widget.betel.phone,
                          );
                          launchUrl(launchUri);
                        },
                        icon: Icon(
                          Icons.call_rounded,
                          color: ColorStyle.primaryColor,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          launch(widget.betel.mapUrl);
                        },
                        icon: Icon(
                          Icons.location_on_rounded,
                          color: ColorStyle.primaryColor,
                          size: 30,
                        )),
                    IconButton(
                        onPressed: () {
                          showMyDialog(widget.betel);
                        },
                        icon: Icon(
                          Icons.info_rounded,
                          color: ColorStyle.primaryColor,
                          size: 30,
                        )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  showMyDialog(Betel betel) {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return FadedScaleAnimation(
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text(
              betel.first_name,
              style: TextStyle(
                  color: ColorStyle.secondaryColor,
                  fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_rounded,
                        size: 15,
                        color: ColorStyle.secondaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Anfitriones:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: ColorStyle.secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    (betel.anf_second_name.isNotEmpty)
                        ? betel.anf_first_name + " &\n" + betel.anf_second_name
                        : betel.anf_first_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on_rounded,
                          size: 15, color: ColorStyle.secondaryColor),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Dirección:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: ColorStyle.secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    betel.direccion_first + "\n" + betel.direccion_second,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_rounded,
                          size: 15, color: ColorStyle.secondaryColor),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Contácto:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: ColorStyle.secondaryColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    betel.contacto,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Cerrar',
                  style: TextStyle(color: Colors.black38),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Betel {
  final String img;
  final String first_name;
  final String second_name;
  final String anf_first_name;
  final String anf_second_name;
  final String direccion_first;
  final String direccion_second;
  final String contacto;
  final String phone;
  final String mapUrl;

  Betel({
    required this.img,
    required this.first_name,
    required this.second_name,
    required this.anf_first_name,
    required this.anf_second_name,
    required this.direccion_first,
    required this.direccion_second,
    required this.contacto,
    required this.phone,
    required this.mapUrl,
  });
}
