import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/firebase/firebase_function.dart';
import 'package:reminder_app/providers/prov_date_time.dart';
import 'package:reminder_app/providers/prov_title_content.dart';

Widget dialogWidget(BuildContext context) {
  DateTimeProv dateTimeProvInstance = Provider.of<DateTimeProv>(context);
  TitleContentProv titleContentProvInstance =
      Provider.of<TitleContentProv>(context);

  String formattedDateTime = DateFormat('dd / MM / yyyy  -  HH : mm')
      .format(dateTimeProvInstance.selectedDateTime);

  return Dialog(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  dateTimeProvInstance.dateTimeFunction(context);
                },
                child: Text(formattedDateTime),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          TextField(
            maxLines: 2,
            minLines: 1,
            controller: titleContentProvInstance.titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 4,
            minLines: 4,
            controller: titleContentProvInstance.contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              FirebaseFunction addFirebase = FirebaseFunction();
              await addFirebase.addToFirestore(
                dateTimeProvInstance.selectedDateTime,
                titleContentProvInstance.titleController.text,
                titleContentProvInstance.contentController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Add Reminder'),
          )
        ],
      ),
    ),
  );
}
