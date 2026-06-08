import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Title: ${message.notification?.title.toString()}");
  log("Body: ${message.notification?.body.toString()}");
  log("Data: ${message.data.toString()}");
}

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
