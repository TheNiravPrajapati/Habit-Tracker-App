import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int currentIndex = 0;

  void setIndex(int i) {
    currentIndex = i;
    notifyListeners();
  }
}
