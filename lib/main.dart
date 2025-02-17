import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'api/firebase_api.dart';
import 'services/notificationService.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  // await NotificationService.initialize();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
    await NotificationService.initialize(() {
    // updateAlarm(); // Call updateAlarm() when notification triggers
  });
  // await LocalNotifications.init();

//  handle in terminated state
  // var initialNotification =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  // if (initialNotification?.didNotificationLaunchApp == true) {
  //   // LocalNotifications.onClickNotification.stream.listen((event) {
  //   Future.delayed(Duration(seconds: 1), () {
  //     // print(event);
  //     navigatorKey.currentState!.pushNamed('/another',
  //         arguments: initialNotification?.notificationResponse?.payload);
  //   });
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(name: 'Ayush'),
    );
  }
}
