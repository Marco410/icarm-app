import 'package:flutter/material.dart';
import 'package:icarm/presentation/components/app_bar_widget.dart';
import 'package:icarm/presentation/components/drawer.dart';

import '../../../../config/setting/style.dart';
import '../../../components/zcomponents.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  const EventScreen({super.key, required this.event});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
      ),
      drawer: const MaterialDrawer(),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 0, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/image/${widget.event.image}",
                  scale: 1.1,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 40, right: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.event.title,
                      textAlign: TextAlign.center,
                      style: TxtStyle.headerStyle.copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.event.text,
                      style: TxtStyle.hintText,
                    ),
                    LineWidget(),
                    Text(
                      "Horario y ubicación",
                      textAlign: TextAlign.center,
                      style: TxtStyle.headerStyle.copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.event.horario,
                      textAlign: TextAlign.center,
                      style: TxtStyle.hintText,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.event.direccion,
                      textAlign: TextAlign.center,
                      style: TxtStyle.hintText,
                    ),
                    LineWidget(),
                    Text(
                      "Acerca del evento",
                      textAlign: TextAlign.center,
                      style: TxtStyle.headerStyle.copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.event.acerca_de,
                      textAlign: TextAlign.center,
                      style: TxtStyle.hintText,
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Text(
                      "Regístrate:",
                      textAlign: TextAlign.center,
                      style: TxtStyle.headerStyle.copyWith(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                              text: "A ti mismo",
                              onTap: () {},
                              margin: EdgeInsets.all(2),
                              size: 'sm',
                              color: Colors.white,
                              loading: false),
                        ),
                        Expanded(
                          child: CustomButton(
                              text: "A otra persona",
                              onTap: () {},
                              margin: EdgeInsets.all(2),
                              size: 'sm',
                              color: ColorStyle.thirdColor,
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
                        onTap: () {},
                        margin: EdgeInsets.all(2),
                        size: 'sm',
                        color: ColorStyle.primaryColor,
                        textColor: Colors.white,
                        loading: false) */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
