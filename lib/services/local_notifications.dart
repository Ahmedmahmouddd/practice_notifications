import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:practice_notifications/main.dart';
import 'package:practice_notifications/model/notification_model.dart';
import 'package:practice_notifications/pages/foreground_app_notification_screen.dart';

class LocalNotificationsService {
  /// private constructor — can't call from outside
  LocalNotificationsService._();
  static final LocalNotificationsService instance =
      LocalNotificationsService._();
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _plugin.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),

      /// For when user tabs on the notification
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;
        final model = NotificationModel.fromPayload(details.payload!);

        navigatorKey.currentState?.pushNamed(
          ForegroundAppNotificationScreen.route,
          arguments: model,
        );
      },
    );

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
