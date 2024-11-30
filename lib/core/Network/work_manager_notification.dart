import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'custom_notification_manager.dart';

class WorkManagerNotification {
  /// Initialize WorkManager with the correct entry point
  static Future<void> init() async {
    await Workmanager().initialize(
      actionTask,
      isInDebugMode: true, // Set to false in production
    );
    await registerTask();
    // print("WorkManager Initialized");
  }

  /// Register a task with unique name and input data
  static Future<void> registerTask() async {
    // Cancel all previous tasks before scheduling a new one
    await Workmanager().cancelAll();

    await Workmanager().registerOneOffTask(
      "uniqueName", // Unique identifier for the task
      "registerPeriodicTask",   // Task name
      inputData: {
        'int': 1,
        'bool': true,
        'double': 1.0,
        'string': 'registerPeriodicTask',
        'array': [1, 2, 3],
      },
    );
    // print("Task Registered");
  }
}
@pragma('vm:entry-point') // Marks this function as a Dart entry-point
void actionTask() {
  Workmanager().executeTask((taskName, inputData) async {
    // print("TaskName: $taskName");
    // print("InputData: $inputData");

    try {
      // Call NotificationManager to schedule a daily notification
      tz.initializeTimeZones();
      await NotificationManager().showScheduleDailyNotification(
        id: 4,
        title: "Reminder",
        body: "This is your daily reminder!",
        hour: 21, // Replace with desired hour
        minute: 3, // Replace with desired minute
      );
      // print("Notification Scheduled Successfully");
    } catch (err) {
      // print("Error during task execution: ${err.toString()}");
      return Future.value(false); // Task failed
    }

    return Future.value(true); // Task completed successfully
  });
}
