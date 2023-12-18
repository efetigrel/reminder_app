import 'package:flutter/material.dart';

class TitleContentProv with ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  @override
  notifyListeners();
}
