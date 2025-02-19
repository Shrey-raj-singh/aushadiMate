import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderSlot extends StatelessWidget {
  const ReminderSlot({
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
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formattedTime, // ✅ Display only HH:mm
                style: const TextStyle(
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
                "$medicineWeight mg",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.av_timer_sharp),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                "Rack $rackNumber",
                style: const TextStyle(
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
