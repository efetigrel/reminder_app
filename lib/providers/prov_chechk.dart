import 'package:flutter/material.dart';

class CheckProv with ChangeNotifier {
  final Map<String, bool> _checkboxValues = {};

  Map<String, bool> get checkboxValues => _checkboxValues;

  setCheckboxValue(String documentId, bool newValue) {
    _checkboxValues[documentId] = newValue;
    notifyListeners();
  }
}
