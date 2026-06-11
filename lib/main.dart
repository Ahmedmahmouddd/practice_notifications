import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practice_notifications/firebase_messaging.dart';
import 'package:practice_notifications/firebase_options.dart';
import 'package:practice_notifications/pages/home_screen.dart';
import 'package:practice_notifications/pages/notification_screen.dart';

// Global navigator key
final _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      home: HomeScreen(),
      routes: {NotificationScreen.route: (context) => NotificationScreen()},
    );
  }
}
