import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icarm/config/setting/style.dart';

class AppBarAuthWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool backButton;
  const AppBarAuthWidget({
    this.backButton = false,
    super.key,
  });

  @override
  State<AppBarAuthWidget> createState() => _AppBarAuthWidgetState();

  final double _prefferedHeight = 45;

  @override
  Size get preferredSize => Size.fromHeight(_prefferedHeight);
}

class _AppBarAuthWidgetState extends State<AppBarAuthWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: (widget.backButton)
          ? InkWell(
              onTap: () => context.pop(),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: ColorStyle.primaryColor,
                size: 26,
              ),
            )
          : InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(
                Icons.menu_rounded,
                color: ColorStyle.primaryColor,
                size: 34,
              ),
            ),
      title: Text(
        "Registrate",
        style: TxtStyle.headerStyle,
      ),
    );
  }
}
