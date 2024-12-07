import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'custom_notification_manager.dart';

class WorkManagerNotification {
  /// Initialize WorkManager with the correct entry point
  static Future<void> init() async {
    await Workmanager().initialize(
      actionTask,
      isInDebugMode: false, // Set to false in production
    );
    await registerTask();
  }

  /// Register a task with unique name and input data
  static Future<void> registerTask() async {
    // Cancel all previous tasks before scheduling a new one
    await Workmanager().cancelAll();

    await Workmanager().registerPeriodicTask(
      "dailyTaskReminder", "sendDailyReminders", // Task name
      frequency: const Duration(days: 1),
      // constraints: Constraints(
      //   networkType: NetworkType.not_required,
      //   requiresDeviceIdle: true,
      // ),

    );
  }
}

@pragma('vm:entry-point')
void actionTask() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      try {
        tz.initializeTimeZones();

        await NotificationManager().showScheduleDailyNotification(
          id: 1,
          title: "Reminder for Today",
          body: "Check your tasks for Today and plan ahead!",
          hour: 7,
          minute: 00,
        );

        await NotificationManager().showScheduleDailyNotification(
          id: 2,
          title: "Complete Your Tasks",
          body: "Don't forget to complete your tasks before their deadline!",
          hour: 17,
          minute: 00,
        );

        return Future.value(true);
      } catch (err) {
        return Future.value(false);
      }
    },
  );
}
