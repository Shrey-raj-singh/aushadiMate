class Reminders {
  final String medicineName;
  final int medicineWeight;
  final String status;
  final DateTime time;
  final int rackNumber;

  Reminders(
      {required this.medicineWeight,
      required this.status,
      required this.rackNumber,
      required this.medicineName,
      required this.time});
}
