import 'dart:async';

import 'package:ausadhimate/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(Function onNotificationTap) async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        onNotificationTap(); // Calls updateAlarm()
        if (response.payload == "alarm_trigger") {}
      },
    );

    // Request notification permissions (for Android 13+)
    await requestPermissions();

    // Initialize time zones
    tz.initializeTimeZones();
  }

  static Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin?
        androidPlatformChannelSpecifics =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlatformChannelSpecifics != null) {
      await androidPlatformChannelSpecifics.requestNotificationsPermission();
    }
  }

  static Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    try {
      tz.initializeTimeZones(); // Ensures time zones are set

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_channel', // Channel ID
            'Reminder Notifications', // Channel Name
            channelDescription: 'Sends scheduled reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode:
            AndroidScheduleMode.exact, // ✅ Correct way to allow Doze Mode
      );
      final Duration delay = scheduledTime.difference(DateTime.now());
      Timer(delay, () {
        print("Triggering updateAlarm() at scheduled time: $scheduledTime");
        updateAlarm();
      });

      print("Notification Scheduled at: $scheduledTime");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  static Future<void> showLocalNotification(String title, String body) async {
    await _notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Notifications',
          channelDescription: 'For Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
    print("Notification with ID $id canceled.");
  }
  
}
