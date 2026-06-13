import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:practice_notifications/main.dart';
import 'package:practice_notifications/pages/background_app_notification_screen.dart';
import 'package:practice_notifications/pages/foreground_app_notification_screen.dart';
import 'package:practice_notifications/pages/killed_app_notification_screen.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Notification received");
}

class FirebaseMessagingService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');

    initPushNotifications();
  }

  void handleBackgroundAppMessage(RemoteMessage? message) {
    if (message == null) return;

    log("Handling message when app is Alive");
    log("Title: ${message.notification?.title.toString()}");
    log("Body: ${message.notification?.body.toString()}");
    log("Data: ${message.data.toString()}");

    navigatorKey.currentState?.pushNamed(
      BackGroundAppNotificationScreen.route,
      arguments: message,
    );
  }

  void handleForegroundAppMessage(RemoteMessage? message) {
    if (message == null) return;

    log("Handling message when app is in Foreground");
    log("Title: ${message.notification?.title.toString()}");
    log("Body: ${message.notification?.body.toString()}");
    log("Data: ${message.data.toString()}");

    navigatorKey.currentState?.pushNamed(
      ForegroundAppNotificationScreen.route,
      arguments: message,
    );
  }

  void handleKilledAppMessage(RemoteMessage? message) {
    if (message == null) return;

    log("Handling message when app is Killed");
    log("Title: ${message.notification?.title.toString()}");
    log("Body: ${message.notification?.body.toString()}");
    log("Data: ${message.data.toString()}");

    navigatorKey.currentState?.pushNamed(
      KilledAppNotificationScreen.route,
      arguments: message,
    );
  }

  Future<void> initPushNotifications() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// Handle background messages
    /// without this, notification will not be sent at all
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    /// Handle messages when app is killed
    /// if removed, notification will still show but no action will be done on opening message
    _firebaseMessaging.getInitialMessage().then(handleKilledAppMessage);

    /// Handle messages when app is Alive in foreground
    /// Shows no notification banner but navigates to the notification screen
    FirebaseMessaging.onMessage.listen(handleForegroundAppMessage);

    /// Handle messages when app is Alive in background
    /// if removed, notification will still show but no action will be done on opening message
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundAppMessage);
  }
}
