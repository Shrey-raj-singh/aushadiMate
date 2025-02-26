import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'Pages/HomePage.dart';
import 'api/firebase_api.dart';
import 'services/notificationService.dart';

final DatabaseReference ref = FirebaseDatabase.instance.ref();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();
  await NotificationService.initialize(() {
    updateAlarm();
  });

  runApp(const MyApp());
}

void updateAlarm() {
  print("Updating alarm...");
  ref.child("alarm").set(1).then((_) {
    print("Alarm updated successfully!");
  }).catchError((error) {
    print("Failed to update alarm: $error");
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ForegroundTaskManager(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(name: 'Ayush'),
      ),
    );
  }
}

class ForegroundTaskManager extends StatefulWidget {
  final Widget child;
  const ForegroundTaskManager({Key? key, required this.child}) : super(key: key);

  @override
  _ForegroundTaskManagerState createState() => _ForegroundTaskManagerState();
}

class _ForegroundTaskManagerState extends State<ForegroundTaskManager> {
  @override
  void initState() {
    super.initState();
    _startForegroundService();
  }

  void _startForegroundService() {
    FlutterForegroundTask.startService(
      notificationTitle: "App Running in Background",
      notificationText: "Maintaining Firebase Connection",
      callback: () {
        _listenToFirebase();
      },
    );
  }

  void _listenToFirebase() {
    ref.child("medTaken").onValue.listen((event) {
      print("New medTaken value: ${event.snapshot.value}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
