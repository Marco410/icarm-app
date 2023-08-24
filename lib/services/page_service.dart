import 'package:flutter/material.dart';

class PageService extends ChangeNotifier {
  int currentIndex = 2;
  int get currentPage => this.currentIndex;

  set currentPageSet(int valor) {
    this.currentIndex = valor;
    notifyListeners();
  }
}
