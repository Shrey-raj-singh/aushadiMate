// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../Models/Reminders.dart';
import 'reminderSlot.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timePeriod,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reminderList.length,
            itemBuilder: (context, index) {
              return ReminderSlot(
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
