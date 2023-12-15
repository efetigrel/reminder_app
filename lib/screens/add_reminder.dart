import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/providers/date_time.dart';

class AddReminder extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  AddReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SelectedDateTime>(
      create: (_) => SelectedDateTime(),
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<SelectedDateTime>(
                builder: (context, selectedDateTime, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await selectedDateTime.selectDate(context);
                        },
                        child: Text(
                          DateFormat('dd.MM.yyyy')
                              .format(selectedDateTime.selectedDate),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await selectedDateTime.selectTime(context);
                        },
                        child: Text(
                          selectedDateTime.selectedTime.format(context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 2,
                minLines: 1,
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 4,
                minLines: 4,
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (titleController.text.isEmpty) {
                  } else {
                    SelectedDateTime selectedDateTime =
                        Provider.of<SelectedDateTime>(context, listen: false);
                    DateTime date = selectedDateTime.selectedDate;
                    TimeOfDay time = selectedDateTime.selectedTime;

                    await FirebaseFirestore.instance
                        .collection('reminders')
                        .add(
                      {
                        'date': date,
                        'check': false,
                        'time':
                            '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                        'title': titleController.text,
                        'content': contentController.text,
                      },
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
