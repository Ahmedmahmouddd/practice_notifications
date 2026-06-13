import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ForegroundAppNotificationScreen extends StatelessWidget {
  const ForegroundAppNotificationScreen({super.key});

  static const route = '/foreground-app-notification-screen';

  @override
  Widget build(BuildContext context) {
    final message =
        ModalRoute.of(context)?.settings.arguments as RemoteMessage?;

    return Scaffold(
      appBar: AppBar(title: Text('Foreground App Notification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message?.notification?.title ?? 'No Title'),
            Text(message?.notification?.body ?? 'No Body'),
            Text(message?.data.toString() ?? 'No Data'),
          ],
        ),
      ),
    );
  }
}
