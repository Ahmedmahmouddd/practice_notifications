import 'package:flutter/material.dart';

class LocalNotificationScreen extends StatelessWidget {
  const LocalNotificationScreen({super.key});

  static const route = '/local-notification-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Local Notification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Local Notification')],
        ),
      ),
    );
  }
}
