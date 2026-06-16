import 'package:flutter/material.dart';
import 'package:practice_notifications/services/local_notifications.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: buttonStyle,
                  onPressed: () =>
                      LocalNotificationsService.instance.showNotification(
                        id: 2,
                        title: "HELLO",
                        body: "AYOOOO this is the body",
                        payload: "go_to_local_notification_screen",
                      ),
                  child: Text("Show Local Notification"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
