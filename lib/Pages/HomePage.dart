// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:ausadhimate/Models/Reminders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/notificationService.dart';
import 'widgets/addReminderForm.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.name});
  final String name;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool addReminder = false;
  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  List<Reminders> reminders = List.empty(growable: true);

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
            onPressed: updateAlarm,
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
                gradientProfileWidget(),
                TimeBlocks(
                  timePeriod: 'Morning',
                  reminderList: reminders,
                ),
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

  // void updateAlarm() {
  //   ref.update({"alarm": 1}).then((_) {
  //     print("Alarm updated successfully!");
  //   }).catchError((error) {
  //     print("Failed to update alarm: $error");
  //   });
  // }

  void updateAlarm() {
    print("object");
    ref.child("alarm").set(1).then((_) {
      print("Alarm updated successfully!");
      setState(() {}); // To refresh the UI
    }).catchError((error) {
      print("Failed to update alarm: $error");
    });
  }

  void onNewReminderSetUp(Reminders reminder) {
    reminders.add(reminder);
    setReminder(reminder.time);
    setState(() {});
  }

  void onDeleteReminder(int index) {
    reminders.removeAt(index);
    setState(() {});
  }

  void setReminder(DateTime reminderTime) {
    NotificationService.scheduleNotification(
      1, // Unique ID for the notification
      "Scheduled Reminder",
      "It's time for your scheduled task!",
      reminderTime,
    );
  }
}

class gradientProfileWidget extends StatelessWidget {
  const gradientProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      margin: EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE2EEBE), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black54,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hey there",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            "Ayush",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await NotificationService.showTestNotification();
            },
            child: const Text('Test Notification'),
          ),
        ],
      ),
    );
  }
}

class TimeBlocks extends StatelessWidget {
  const TimeBlocks({
    super.key,
    required this.timePeriod,
    required this.reminderList,
  });
  final String timePeriod;
  final List<Reminders> reminderList;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timePeriod,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reminderList.length,
            itemBuilder: (context, index) {
              return MedicineSlot(
                  medicine: reminderList[index].medicineName,
                  time: reminderList[index].time,
                  medicineWeight: reminderList[index].medicineWeight,
                  status: reminderList[index].status,
                  rackNumber: reminderList[index].rackNumber);
            },
          ),
        ],
      ),
    );
  }
}

class MedicineSlot extends StatelessWidget {
  const MedicineSlot({
    super.key,
    required this.medicine,
    required this.time,
    required this.medicineWeight,
    required this.status,
    required this.rackNumber,
  });

  final String medicine;
  final DateTime time;
  // final String time;
  final int medicineWeight;
  final String status;
  final int rackNumber;

  @override
  Widget build(BuildContext context) {
    // Parse and format time correctly
    String formattedTime = _formatTime(time);
    // Triggers in 10 seconds

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      height: 92,
      decoration: BoxDecoration(
          color: const Color(0xFF7be8c9),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                medicine,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedTime, // ✅ Display only HH:mm
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "${medicineWeight} mg",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 20),
              Icon(Icons.av_timer_sharp),
              Text(
                status,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                "Rack ${rackNumber}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to format time
  String _formatTime(DateTime time) {
    try {
      // DateTime dateTime = DateTime.parse(time);
      return DateFormat.jm().format(time); // Outputs like "08:30 AM"
    } catch (e) {
      return "error"; // Fallback if parsing fails
    }
  }
}
