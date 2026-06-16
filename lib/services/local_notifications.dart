import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:practice_notifications/main.dart';
import 'package:practice_notifications/models/notification_model.dart';
import 'package:practice_notifications/pages/foreground_app_notification_screen.dart';
import 'package:practice_notifications/pages/local_notification_screen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone.identifier));
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

    await _configureLocalTimeZone();
  }

  static const AndroidNotificationChannel highImportanceChannel =
      AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications.',
        importance: Importance.max,
      );

  Future<void> showInstantNotification({
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

  Future<void> showPeriodicNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required RepeatInterval repeatInterval,
  }) async {
    await _plugin.periodicallyShow(
      id: id,
      title: title,
      body: body,
      payload: payload,
      repeatInterval: repeatInterval,
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
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  Future<void> showSchedualedNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint('Scheduled time already passed today.');
      return;
    }
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
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
      androidScheduleMode: AndroidScheduleMode.inexact,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
