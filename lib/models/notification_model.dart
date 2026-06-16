import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationModel {
  final String? title;
  final String? body;

  const NotificationModel({this.title, this.body});

  factory NotificationModel.fromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      title: message.notification?.title,
      body: message.notification?.body,
    );
  }

  factory NotificationModel.fromPayload(String payload) {
    final map = jsonDecode(payload) as Map<String, dynamic>;
    return NotificationModel(
      title: map['title'] as String?,
      body: map['body'] as String?,
    );
  }

  // When showing local notification — attach this string
  String toPayload() {
    return jsonEncode({'title': title, 'body': body});
  }
}
