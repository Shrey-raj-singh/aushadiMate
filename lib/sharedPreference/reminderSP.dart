
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderService {
  static Future<void> saveReminders(List<Map<String, dynamic>> remindersList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(remindersList);
    await prefs.setString('remindersList', encodedData);
  }

  static Future<List<Map<String, dynamic>>> getReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('remindersList');
    if (data != null) {
      List<dynamic> decodedData = jsonDecode(data);
      return decodedData.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }
}
