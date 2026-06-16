import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:practice_notifications/main.dart';
import 'package:practice_notifications/model/notification_model.dart';
import 'package:practice_notifications/pages/foreground_app_notification_screen.dart';
import 'package:practice_notifications/pages/local_notification_screen.dart';

class LocalNotificationsService {
  /// private constructor — can't call from outside
  LocalNotificationsService._();
  static final LocalNotificationsService instance =
      LocalNotificationsService._();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  String? _pendingPayload;

  void _navigateByPayload(String payload, NavigatorState nav) {
    if (payload == 'go_to_local_notification_screen') {
      nav.pushNamed(LocalNotificationScreen.route, arguments: payload);
      return;
    }
    final model = NotificationModel.fromPayload(payload);
    nav.pushNamed(ForegroundAppNotificationScreen.route, arguments: model);
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    final nav = navigatorKey.currentState;
    if (nav == null) {
      _pendingPayload = payload; // app not mounted yet
      return;
    }

    _navigateByPayload(payload, nav);
  }

  void flushPendingNavigation() {
    final payload = _pendingPayload;
    if (payload == null) return;
    _pendingPayload = null;
    _handleNotificationTap(payload);
  }

  Future<void> init() async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),

      /// For when user tabs on the notification
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap(details.payload);
      },
    );

    /// Cold start tap (app was terminated)
    final NotificationAppLaunchDetails? launchDetails = await _plugin
        .getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final NotificationResponse? response =
          launchDetails!.notificationResponse;
      _handleNotificationTap(response?.payload);
    }

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(highImportanceChannel);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static const AndroidNotificationChannel highImportanceChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications.',
        importance: Importance.max,
      );

  Future<void> showNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          highImportanceChannel.id,
          highImportanceChannel.name,
          channelDescription: highImportanceChannel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
