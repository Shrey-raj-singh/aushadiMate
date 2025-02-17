import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Models/Reminders.dart';

class AddReminderDialog extends StatefulWidget {
  final Function(Reminders) onAddReminder;

  const AddReminderDialog({super.key, required this.onAddReminder});

  @override
  _AddReminderDialogState createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<AddReminderDialog> {
  final TextEditingController _medicineController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  TimeOfDay? _selectedTime;
  int _selectedRackNumber = 1; // Default to 1

  // Function to pick time
  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // Function to convert TimeOfDay to formatted string
  String _formatTime(TimeOfDay? time) {
    if (time == null) return "Choose Time";
    final now = DateTime.now();
    final formatted = DateFormat('hh:mm a')
        .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
    return formatted; // e.g., "08:30 PM"
  }

  // Function to add reminder
  void _addReminder() {
    if (_medicineController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields before adding a reminder!")),
      );
      return;
    }

    Reminders newReminder = Reminders(
      medicineName: _medicineController.text,
      medicineWeight: int.tryParse(_weightController.text) ?? 0, // Convert safely
      time: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      rackNumber: _selectedRackNumber,
      status: "Pending",
    );

    widget.onAddReminder(newReminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add Reminder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _medicineController,
              decoration: InputDecoration(labelText: "Medicine Name", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Medicine Weight (mg)", border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: "Select Rack Number", border: OutlineInputBorder()),
              value: _selectedRackNumber,
              items: [1, 2, 3].map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedRackNumber = newValue!);
              },
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () => _pickTime(context),
              child: InputDecorator(
                decoration: InputDecoration(labelText: "Select Time", border: OutlineInputBorder()),
                child: Text(_formatTime(_selectedTime), style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReminder,
              child: Text("Add Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}
