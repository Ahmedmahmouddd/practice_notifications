import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:practice_notifications/services/local_notifications.dart';
import 'package:practice_notifications/widgets/custom_icon_button.dart';
import 'package:practice_notifications/widgets/date_and_time_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Instant Notification
                CustomIconButton(
                  onPressed: () => LocalNotificationsService.instance
                      .showInstantNotification(
                        id: 1,
                        title: "HELLO",
                        body: "YO this is an instant notification",
                        payload: "go_to_local_notification_screen",
                      ),
                  icon: Icons.notifications_active_outlined,
                  text: "Show Local Notification",
                ),

                /// Periodic Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      onPressed: () => LocalNotificationsService.instance
                          .showPeriodicNotification(
                            id: 2,
                            title: "Periodic Notification",
                            body: "AM I ever gonna shut up",
                            payload: "go_to_local_notification_screen",
                            repeatInterval: RepeatInterval.everyMinute,
                          ),
                      icon: Icons.timer_outlined,
                      text: "Show Periodic Notification",
                    ),

                    /// Delete Notification
                    IconButton(
                      onPressed: () => LocalNotificationsService.instance
                          .cancelNotification(2),
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),

                /// Scheduled Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      onPressed: () async {
                        final scheduledDate = await pickScheduleDateTime(
                          context,
                        );
                        if (scheduledDate == null) return;
                        LocalNotificationsService.instance
                            .showSchedualedNotification(
                              id: 3,
                              title: "Scheduled Notification",
                              body:
                                  'Scheduled for ${formatScheduleDateTime(scheduledDate)}',
                              payload: "go_to_local_notification_screen",
                              scheduledDate: scheduledDate,
                            );
                      },

                      icon: Icons.access_time_outlined,
                      text: "Show Scheduled Notification",
                    ),

                    /// Delete Notification
                    IconButton(
                      onPressed: () => LocalNotificationsService.instance
                          .cancelNotification(3),
                      icon: Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),

                /// Cancel All Notifications
                IconButton(
                  onPressed: () => LocalNotificationsService.instance
                      .cancelAllNotifications(),
                  icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
