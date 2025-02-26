class Reminders {
  String medicineName;
  DateTime time;
  int notificationId; // Unique notification ID
  int medicineWeight;
  String status;
  int rackNumber;

  Reminders({
    required this.medicineName,
    required this.time,
    required this.notificationId, // Initialize in constructor
    required this.medicineWeight,
    required this.status,
    required this.rackNumber,
  });

  factory Reminders.fromJson(Map<String, dynamic> json) {
    return Reminders(
      medicineName: json['medicineName'],
      time: DateTime.parse(json['time']),
      notificationId: json['notificationId'], // Load from JSON
      medicineWeight: json['medicineWeight'],
      status: json['status'],
      rackNumber: json['rackNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'time': time.toIso8601String(),
      'notificationId': notificationId, // Save in JSON
      'medicineWeight': medicineWeight,
      'status': status,
      'rackNumber': rackNumber,
    };
  }
}
