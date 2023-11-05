import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';
import 'package:icarm/presentation/components/zcomponents.dart';

class KidsPage extends StatefulWidget {
  const KidsPage({super.key});

  @override
  State<KidsPage> createState() => _KidsPageState();
}

class _KidsPageState extends State<KidsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset("assets/image/kids.png"),
              Image.asset("assets/image/logo-kids.png"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: Column(
              children: [
                Text(
                  "Registra a tus hijos",
                  style: TxtStyle.headerStyle,
                ),
                LineWidget()
              ],
            ),
          ),
          CustomButton(
            text: "Registrar",
            onTap: () {
              context.pushNamed('kidsAdd');
            },
            loading: false,
            textColor: Colors.white,
            color: ColorStyle.secondaryColor,
          )
        ],
      ),
    );
  }
}
