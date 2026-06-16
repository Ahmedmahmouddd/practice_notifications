import 'package:flutter/material.dart';
import 'package:practice_notifications/models/notification_model.dart';

class ForegroundAppNotificationScreen extends StatelessWidget {
  const ForegroundAppNotificationScreen({super.key});

  static const route = '/foreground-app-notification-screen';

  @override
  Widget build(BuildContext context) {
    final model =
        ModalRoute.of(context)?.settings.arguments as NotificationModel?;

    return Scaffold(
      appBar: AppBar(title: Text('Foreground App Notification')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(model?.title ?? 'No Title'),
            Text(model?.body ?? 'No Body'),
          ],
        ),
      ),
    );
  }
}
