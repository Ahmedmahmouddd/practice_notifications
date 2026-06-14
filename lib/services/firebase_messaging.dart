import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:practice_notifications/main.dart';
import 'package:practice_notifications/model/notification_model.dart';
import 'package:practice_notifications/pages/background_app_notification_screen.dart';
import 'package:practice_notifications/pages/killed_app_notification_screen.dart';
import 'package:practice_notifications/services/local_notifications.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Notification received");
}

class FirebaseMessagingService {
  FirebaseMessagingService._();
  static final FirebaseMessagingService instance = FirebaseMessagingService._();

  final _firebaseMessaging = FirebaseMessaging.instance;

  // Channel is defined and registered on the device in LocalNotificationsService.
  // When we show a foreground notification, we pass androidNotificationChannel.id
  // into AndroidNotificationDetails (next step).

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');

    initPushNotifications();
  }

  /// handle onMessageOpenedApp event
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

  /// handle onMessage event
  void handleForegroundAppMessage(RemoteMessage? message) {
    if (message == null) return;

    log("Handling message when app is in Foreground");
    log("Title: ${message.notification?.title.toString()}");
    log("Body: ${message.notification?.body.toString()}");
    log("Data: ${message.data.toString()}");

    final model = NotificationModel.fromRemoteMessage(message);

    LocalNotificationsService.instance.showNotification(
      id: message.notification.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      payload: model.toPayload(),
    );
  }

  /// handle onInitialMessage event
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

    /// Handle messages when app is killed
    /// if removed, notification will still show but no action will be done on opening message
    _firebaseMessaging.getInitialMessage().then(handleKilledAppMessage);

    /// Handle messages when app is Alive in foreground
    FirebaseMessaging.onMessage.listen(handleForegroundAppMessage);

    /// Handle messages when app is Alive in background
    /// if removed, notification will still show but no action will be done on opening message
    FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundAppMessage);
  }
}
