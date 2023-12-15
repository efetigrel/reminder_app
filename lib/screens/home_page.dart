import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/providers/check.dart';
import 'package:reminder_app/providers/date_time.dart';
import 'package:reminder_app/screens/add_reminder.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reminders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Display reminders
          List<DocumentSnapshot> reminders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              var reminder = reminders[index];
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: reminder['check'],
                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .collection('reminders')
                              .doc(reminder.id)
                              .update(
                            {
                              'check': value,
                            },
                          );
                        },
                      ),
                      title: Row(
                        children: [
                          Text('${_formatTimestamp(reminder['date'])} '),
                          const SizedBox(width: 10),
                          Text('${reminder['time']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDeleteDialog(context, reminder.id);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${reminder['title']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            '${reminder['content']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<Check>(
                    create: (context) => Check(),
                  ),
                  ChangeNotifierProvider<SelectedDateTime>(
                    create: (context) => SelectedDateTime(),
                  ),
                ],
                child: AddReminder(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

  return formattedDate;
}

void _deleteReminder(String reminderId) {
  FirebaseFirestore.instance
      .collection('reminders')
      .doc(reminderId)
      .delete()
      .then(
        (value) {},
      )
      .catchError(
    (error) {
      print(error);
    },
  );
}

void _confirmDeleteDialog(BuildContext context, String reminderId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Delete Confirmation',
          style: TextStyle(fontSize: 25),
        ),
        content: const Text(
          'Are you sure you want to delete? \nDeleted data cannot be recovered!',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteReminder(reminderId);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
