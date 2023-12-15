import 'package:flutter/material.dart';

class Check with ChangeNotifier {
  bool value = false;

  void checkIt(bool newValue) {
    value = newValue;
    notifyListeners();
  }
}
