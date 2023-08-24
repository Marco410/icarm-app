import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:icarm/screen/setting/themes.dart';

import 'package:icarm/generated/l10n.dart';

import 'package:icarm/screen/screens.dart';

import 'package:icarm/setting/style.dart';

// ignore: must_be_immutable
class setting extends StatefulWidget {
  ThemeBloc? themeBloc;

  setting({Key? key, this.themeBloc}) : super(key: key);

  _settingState createState() => _settingState(themeBloc!);
}

class _settingState extends State<setting> {
  ThemeBloc themeBloc;
  _settingState(this.themeBloc);
  bool theme = true;
  String _img = "assets/image/setting/lightMode.png";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.2,
        iconTheme: IconThemeData(
            color: Theme.of(context).textSelectionTheme.selectionHandleColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          S.of(context)!.settings,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionHandleColor,
              fontFamily: "Popins",
              fontSize: 17.0),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                ///
                /// Change image header and theme color if user click image
                ///
                if (theme == true) {
                  setState(() {
                    _img = "assets/image/setting/nightMode.png";
                    theme = false;
                  });
                  themeBloc.selectedTheme.add(_buildLightTheme());
                } else {
                  themeBloc.selectedTheme.add(_buildDarkTheme());
                  setState(() {
                    theme = true;
                    _img = "assets/image/setting/lightMode.png";
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  height: 125.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      image: DecorationImage(
                          image: AssetImage(_img), fit: BoxFit.cover)),
                ),
              ),
            ),
            /* 
              SizedBox(
                height: 20.0,
              ),
              listSetting("SIGNAL NOTIFICATION", "Enabled"), */
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    PageRouteBuilder(pageBuilder: (_, __, ___) => new login()));
              },
              child: listSetting(S.of(context)!.sesion, S.of(context)!.signOut),
            ),
            SizedBox(
              height: 10.0,
            ),

            /* ///
              /// Navigate to theme screen
              ///
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new seeAllTemplate()));
                  },
                  child: listSetting("UI KIT WALLET", "See all template")), */
          ],
        ),
      ),
    );
  }

  Widget listSetting(String header, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            header,
            style: TextStyle(
                color: Theme.of(context).hintColor,
                fontFamily: "Sans",
                fontSize: 13.0),
          ),
          SizedBox(
            height: 9.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontSize: 17.0,
                    fontFamily: "Popins",
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300),
              ),
              Icon(Icons.keyboard_arrow_right)
            ],
          ),
          line()
        ],
      ),
    );
  }

  Widget line() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: double.infinity,
        height: 0.5,
        decoration: BoxDecoration(color: Theme.of(context).hintColor),
      ),
    );
  }

  ///
  /// Change to mode light theme
  ///
  DemoTheme _buildLightTheme() {
    return DemoTheme(
        'light',
        ThemeData(
          brightness: Brightness.light,
          primaryColor: colorStyle.primaryColor,
          cardColor: colorStyle.cardColorLight,
          scaffoldBackgroundColor: Color(0xFFFDFDFD),
          canvasColor: colorStyle.whiteBacground,
          dividerColor: colorStyle.iconColorLight,
          hintColor: colorStyle.fontSecondaryColorLight,
          textSelectionTheme:
              TextSelectionThemeData(selectionColor: colorStyle.fontColorLight),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: colorStyle.primaryColor),
        ));
  }

  ///
  /// Change to mode dark theme
  ///
  DemoTheme _buildDarkTheme() {
    return DemoTheme(
        'dark',
        ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: colorStyle.background,
            backgroundColor: colorStyle.blackBackground,
            dividerColor: colorStyle.iconColorDark,
            primaryColor: colorStyle.primaryColor,
            hintColor: colorStyle.fontSecondaryColorDark,
            canvasColor: colorStyle.grayBackground,
            cardColor: colorStyle.grayBackground,
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: colorStyle.primaryColor),
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: colorStyle.fontColorDark,
              selectionHandleColor: colorStyle.fontColorDarkTitle,
            )));
  }

  void _mostrarAlert(BuildContext context) {
    String _vista = S.of(context)!.select;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context)!.languaje),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton(
                  items: [...S.delegate.supportedLocales]
                      .map((e) => DropdownMenuItem(
                            child: Text(_localizeLocale(context, e)),
                            value: e.toString(),
                          ))
                      .toList(),
                  onChanged: (_value) {},
                  hint: Text(_vista),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(S.of(context)!.cancel))
            ],
          );
        });
  }

  String _localizeLocale(BuildContext context, Locale locale) {
    // ignore: unnecessary_null_comparison
    if (locale == null) {
      String local =
          Locale(Localizations.localeOf(context).toString()).toString();
      String ubicacion = local.toString();

      return ubicacion[0].toUpperCase() + ubicacion.substring(1);
    } else {
      final localeString = locale.toString();
      return localeString[0].toUpperCase() + localeString.substring(1);
    }
  }
}
