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
        const SnackBar(content: Text("Please fill all fields before adding a reminder!")),
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
      status: "Pending", notificationId: 0,
    );

    widget.onAddReminder(newReminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Add Reminder", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _medicineController,
              decoration: const InputDecoration(labelText: "Medicine Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Medicine Weight (mg)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Select Rack Number", border: OutlineInputBorder()),
              value: _selectedRackNumber,
              items: [1, 2, 3].map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text(value.toString()));
              }).toList(),
              onChanged: (newValue) {
                setState(() => _selectedRackNumber = newValue!);
              },
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _pickTime(context),
              child: InputDecorator(
                decoration: const InputDecoration(labelText: "Select Time", border: OutlineInputBorder()),
                child: Text(_formatTime(_selectedTime), style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReminder,
              child: const Text("Add Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}
