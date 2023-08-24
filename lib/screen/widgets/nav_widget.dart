import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavWidget extends StatelessWidget {
  NavWidget({Key? key, required this.title}) : super(key: key);

  String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0.2,
      iconTheme: IconThemeData(
          color: Theme.of(context).textSelectionTheme.selectionHandleColor),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).textSelectionTheme.selectionHandleColor,
            fontFamily: "Popins",
            fontSize: 17.0),
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }
}
