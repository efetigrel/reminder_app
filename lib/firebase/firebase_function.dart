import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseFunction with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToFirestore(
      DateTime selectedDateTime, titleController, contentController) async {
    try {
      print('Adding to Firestore...');
      await _firestore.collection('reminders').add({
        'date_time': selectedDateTime,
        'title': titleController,
        'content': contentController,
        'check': false,
      });

      print('Data added successfully, and notification scheduled.');
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}
