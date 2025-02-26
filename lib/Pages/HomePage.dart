// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:ui';

import 'package:ausadhimate/Models/Reminders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../main.dart';
import '../services/notificationService.dart';
import 'widgets/addReminderForm.dart';
import 'widgets/gradientProfileBlock.dart';
import 'widgets/reminderSlot.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.name});
  final String name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool addReminder = false;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();
  DatabaseReference refer = FirebaseDatabase.instance.ref('/MedTaken');
  Object? medTaken = 0;
  List<Reminders> reminders = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    loadMedTaken();
    refer.onValue.listen((DatabaseEvent event) async {
      final data = event.snapshot.value;
      print("Fetched Data: $data");

      if (data != null && medTaken != data) {
        // Ensure data is not null before comparison
        await NotificationService.showLocalNotification(
            "Medicine Taken", "You have taken your medicine!");
        setState(() {
          medTaken = data; // Use setState to update UI
        });
        saveMedTakenValue(data);
      }
    });

    loadReminders();
    // scheduleBackgroundTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            // Handle settings action
          },
        ),
        title: const Text("Ausadhimate", textAlign: TextAlign.center),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert),
            onPressed: updateAlarmToZero,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddReminderDialog(
                  onAddReminder: onNewReminderSetUp,
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientProfileWidget(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Morning MedTaken: $medTaken",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onDoubleTap: () => onDeleteReminder(index),
                            child: ReminderSlot(
                                medicine: reminders[index].medicineName,
                                time: reminders[index].time,
                                medicineWeight: reminders[index].medicineWeight,
                                status: reminders[index].status,
                                rackNumber: reminders[index].rackNumber),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          (addReminder
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      addReminder = false;
                    });
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3)),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 240,
                            height: 380,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(179, 0, 0, 0),
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox()),
        ],
      ),
    );
  }

// Only update the name, leave the age and address!

  Future<void> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? remindersString = prefs.getString('reminders');

    if (remindersString != null) {
      final List<dynamic> decodedList = json.decode(remindersString);
      setState(() {
        reminders =
            decodedList.map((item) => Reminders.fromJson(item)).toList();
      });
    }
  }

  Future<void> saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedReminders =
        json.encode(reminders.map((r) => r.toJson()).toList());
    await prefs.setString('reminders', encodedReminders);
  }

  Future<void> loadMedTaken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      medTaken =
          prefs.getInt("medTaken") ?? 0; // Default to 0 if no data exists
    });
  }

  Future<void> saveMedTakenValue(Object? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt("medTaken", value);
    } else if (value is String) {
      await prefs.setString("medTaken", value);
    } else if (value is bool) {
      await prefs.setBool("medTaken", value);
    }
  }

  void updateAlarm() {
    ref.child("alarm").set(1).then((_) {
      setState(() {}); // To refresh the UI
    }).catchError((error) {});
  }

  void updateAlarmToZero() {
    ref.child("alarm").set(0).then((_) {
      setState(() {}); // To refresh the UI
    }).catchError((error) {});
  }

  void onNewReminderSetUp(Reminders reminder) {
    int uniqueNotificationId = DateTime.now()
        .millisecondsSinceEpoch
        .remainder(100000); // Generate a unique ID

    reminder.notificationId = uniqueNotificationId; // Assign the ID
    print(reminder);
    setState(() {
      reminders.add(reminder);
    });
    saveReminders(); // Save updated reminders list

    setReminder(reminder.time,
        uniqueNotificationId); // Pass the ID to schedule the notification
  }

  void onDeleteReminder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Reminder?"),
        content: Text("Are you sure you want to delete this reminder?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              int notificationId =
                  reminders[index].notificationId; // Get the notification ID

              NotificationService.cancelNotification(
                  notificationId); // Cancel notification

              setState(() {
                reminders.removeAt(index);
              });
              saveReminders();

              Navigator.pop(context); // Close the dialog
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void setReminder(DateTime reminderTime, int notificationId) {
    NotificationService.scheduleNotification(
      notificationId, // Use unique ID
      "Scheduled Reminder",
      "It's time for your medicine!",
      reminderTime,
    );
  }

  // void scheduleBackgroundTask() {
  //   Workmanager().registerPeriodicTask(
  //     "checkBackend",
  //     checkBackendTask,
  //     frequency: Duration(minutes: 15), // Minimum interval is 15 mins
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //   );
  // }
}
