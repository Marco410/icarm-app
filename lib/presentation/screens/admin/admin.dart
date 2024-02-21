import 'package:flutter/Material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/setting/style.dart';
import '../../components/zcomponents.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.whiteBacground,
      appBar: AppBarWidget(
        backButton: true,
        rightButtons: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Administración",
            style: TxtStyle.headerStyle,
          ),
          SizedBox(
            height: 15,
          ),
          BigButtonWidget(
            title: "Eventos",
            icon: Icons.calendar_month_rounded,
            onTap: () => context.pushNamed("eventos"),
          ),
        ],
      ),
    );
  }
}

class BigButtonWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onTap;
  const BigButtonWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorStyle.secondaryColor,
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: ColorStyle.whiteBacground,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  title,
                  style: TxtStyle.headerWhiteStyle
                      .copyWith(color: ColorStyle.whiteBacground, fontSize: 21),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 30,
              color: ColorStyle.whiteBacground,
            )
          ],
        ),
      ),
    );
  }
}
