// ignore_for_file: file_names

import 'package:flutter/material.dart';


class GradientProfileWidget extends StatelessWidget {
  const GradientProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 5,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE2EEBE), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black54,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hey there",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Ayush",
            style: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     await NotificationService.showLocalNotification("Test","This is for testing!");
          //   },
          //   child: const Text('Test Notification'),
          // ),
        ],
      ),
    );
  }
}
