class Reminders {
  String medicineName;
  int medicineWeight;
  DateTime time;
  int rackNumber;
  String status;

  Reminders({
    required this.medicineName,
    required this.medicineWeight,
    required this.time,
    required this.rackNumber,
    required this.status,
  });

  // Convert Reminders object to JSON
  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'medicineWeight': medicineWeight,
      'time': time.toIso8601String(), // Store DateTime as a string
      'rackNumber': rackNumber,
      'status': status,
    };
  }

  // Convert JSON to Reminders object
  factory Reminders.fromJson(Map<String, dynamic> json) {
    return Reminders(
      medicineName: json['medicineName'],
      medicineWeight: json['medicineWeight'],
      time: DateTime.parse(json['time']), // Convert string back to DateTime
      rackNumber: json['rackNumber'],
      status: json['status'],
    );
  }
}
