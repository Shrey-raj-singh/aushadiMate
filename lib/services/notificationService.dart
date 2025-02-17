import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer';

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
        if (response.payload == "alarm_trigger") {
          onNotificationTap(); // Calls updateAlarm()
        }
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
      print("Notification Scheduled at: $scheduledTime");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }

  static Future<void> showTestNotification() async {
    await _notificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'For testing purposes',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
