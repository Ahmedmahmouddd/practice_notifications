import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:practice_notifications/firebase_options.dart';
import 'package:practice_notifications/pages/background_app_notification_screen.dart';
import 'package:practice_notifications/pages/foreground_app_notification_screen.dart';
import 'package:practice_notifications/pages/home_screen.dart';
import 'package:practice_notifications/pages/killed_app_notification_screen.dart';
import 'package:practice_notifications/services/firebase_messaging.dart';
import 'package:practice_notifications/services/local_notifications.dart';

// Global navigator key
final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  await LocalNotificationsService.instance.init();
  await FirebaseMessagingService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: HomeScreen(),
      navigatorKey: navigatorKey,
      routes: {
        KilledAppNotificationScreen.route: (context) =>
            KilledAppNotificationScreen(),
        BackGroundAppNotificationScreen.route: (context) =>
            BackGroundAppNotificationScreen(),
        ForegroundAppNotificationScreen.route: (context) =>
            ForegroundAppNotificationScreen(),
      },
    );
  }
}
