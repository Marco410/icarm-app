// ignore_for_file: must_be_immutable

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:icarm/setting/style.dart';
import 'package:url_launcher/url_launcher.dart';

class ChurchPage extends StatefulWidget {
  const ChurchPage({
    Key? key,
  }) : super(key: key);
  @override
  State<ChurchPage> createState() => _ChurchPageState();
}

class _ChurchPageState extends State<ChurchPage> {
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
        child: Container(
          padding: EdgeInsets.only(top: 15, left: 30, right: 30),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black87),
                  child: ImageIcon(
                    AssetImage("assets/image/logo.png"),
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Amor & Restauración Morelia",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Somos una iglesia que busca hacer de cada persona un siervo líder, fiel, capaz y comprometido con Dios, que adquiera y reproduzca el carácter de Jesús en otras personas",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 15,
                ),
                TitleWidget(
                  title: "Misión",
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Hacer de cada persona común, siervos lideres fieles, capaces y comprometidos con Dios. Nuestra visión es alcanzar y transformar.",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 15,
                ),
                TitleWidget(
                  title: "Nuestra histora",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Cómo comenzó todo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '"Y de esta manera me esforcé a predicar el evangelio, no donde Cristo ya hubiese sido nombrado, para no edificar sobre fundamento ajeno, sino, como está escrito: Aquellos a quienes nunca les fue anunciado acerca de él, verán; Y los que nunca han oído de él, entenderán." \n- Romanos 15:20-21',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'En el año 2007 en el mes de Noviembre, el pastor Omar Jaramillo recibió una instrucción de parte del Espíritu Santo cuando se encontraba sirviendo a Dios. La instrucción de Dios era dejarlo todo, y venir a la ciudad de Morelia.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'A pesar de las adversidades el pastor decidió obedecer a Dios y dejándolo todo vino a Morelia, sin nada asegurado, ni un techo, ni familia, ni recursos, pero con una palabra de fe.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Apenas llego, empezó a trabajar para el reino ardientemente, y con solo 10 personas celebraron el primer servicio un 14 de Noviembre de ese mismo año. Pusieron por nombre a la iglesia “Centro de Restauración Familiar Emanuel”. A los 6 meses recibió la cobertura de los Apóstoles Pedro y Lety Cantú de la iglesia Amor & Restauración Houston, y se cambió el nombre de la iglesia a “Amor & Restauración Morelia”. Desde el comienzo hemos trabajado apasionadamente intentando cumplir la visión que nació en el corazón de Dios para nosotros, y a pesar de toda circunstancia y problema, siempre alzando la bandera de la Fe y trabajando sin desmayar.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Hoy a 13 años hemos experimentado un maravilloso crecimiento , pues miles de personas han venido a la salvación de Cristo , Dios a traído gente maravillosa y creativa a las filas de la iglesia; Personas que han servido a Dios con todo su corazón, personas que han vivido una transformación real y verdadera.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Estamos agradecidos con Dios por su fidelidad , pues hasta el dia de hoy ha estado con nosotros.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '¡ALELUYA!',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '"Hasta aquí nos ayudó Jehová" \n 1 Samuel 7:12',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "https://www.amoryrestauracionmorelia.org/whatsapp");
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
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  String title;
  TitleWidget({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: 26,
            color: colorStyle.secondaryColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
