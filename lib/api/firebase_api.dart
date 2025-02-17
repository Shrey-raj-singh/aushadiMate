import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotification() async{
    // await _firebaseMessaging.requestPermission();
    // final fCMRoken = await _firebaseMessaging.getToken();
    // print('Token: $fCMRoken');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // return token;
    });
    String? token = await _firebaseMessaging.getToken();
    print('Token: $token');
  }
}