import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:icarm/config/setting/style.dart';

class DemoTheme {
  final String name;
  final ThemeData data;

  const DemoTheme(this.name, this.data);
}

class ThemeBloc {
  final Stream<ThemeData> themeDataStream;
  final Sink<DemoTheme> selectedTheme;

  factory ThemeBloc() {
    final selectedTheme = PublishSubject<DemoTheme>();
    final themeDataStream = selectedTheme.distinct().map((theme) => theme.data);
    return ThemeBloc._(themeDataStream, selectedTheme);
  }

  const ThemeBloc._(this.themeDataStream, this.selectedTheme);

  DemoTheme initialTheme() {
    return DemoTheme(
        'initial',
        ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: ColorStyle.background,
            primaryColor: ColorStyle.primaryColor,
            textSelectionTheme: TextSelectionThemeData(), colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: ColorStyle.primaryColor).copyWith(surface: ColorStyle.blackBackground)));
  }
}
