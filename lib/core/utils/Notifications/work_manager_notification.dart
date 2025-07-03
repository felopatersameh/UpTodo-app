import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../Network/serves_locator.dart';
import '../../model/task_model.dart';
import 'custom_notification_manager.dart';

class WorkManagerNotification {
  static final WorkManagerNotification _instance =
      WorkManagerNotification._internal();

  WorkManagerNotification._internal();

  factory WorkManagerNotification() {
    return _instance;
  }

  Future<void> init() async {
    final settingsBox = getIt.get<Box<bool>>();
    final isWorkManagerActive = settingsBox.get('isWorkManagerActive', defaultValue: null);
    if (isWorkManagerActive == false) {
      return;
    }
    await Workmanager().initialize(
      _actionTask,
      isInDebugMode: false, 
    );
    await registerTask();
    await settingsBox.put('isWorkManagerActive', true);
  }

  Future<void> registerTask() async {
    await Workmanager().cancelAll();
   
    await Workmanager().registerPeriodicTask(
      "dailyTaskReminder",
      "sendDailyReminders", // Task name
      frequency: const Duration(days: 1),
      // Add constraints if needed
      // constraints: Constraints(
      //   networkType: NetworkType.not_required,
      //   requiresDeviceIdle: true,
      // ),
    );
  }


}

@pragma('vm:entry-point')
void _actionTask() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      tz.initializeTimeZones();
      
      final box = await Hive.openBox<TaskModel>('taskBox');
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      final todayTasks = box.values
          .where(
            (task) =>
                DateFormat('yyyy-MM-dd').format(task.dateTime) == todayStr,
          )
          .toList();

      if (todayTasks.isEmpty) {
      
        await NotificationManager().showScheduleDailyNotification(
          hour: 7,
          minute: 0,
          id: 100,
          title: "Start your day!",
          body: "Add new tasks and start your day with activity!",
        );
      } else {
        final completed = todayTasks.where((t) => t.isCompleted).length;
        if (completed == todayTasks.length) {
          // all tasks are completed
          await NotificationManager().showScheduleDailyNotification(
            hour: 7,
            minute: 0,
            id: 101,
            title: "Well done!",
            body: "You have completed all your tasks for today. Keep up the good work!",
          );
        } else {
          // there are tasks not completed
          final notDone = todayTasks.length - completed;
          await NotificationManager().showScheduleDailyNotification(
            hour: 17,
            minute: 0,
            id: 102,
            title: "Your tasks are not complete yet!",
            body: "You have $notDone tasks not completed today. Remember to complete them!",
          );
        }
      }
      return Future.value(true);
    } catch (err) {
      return Future.value(false);
    }
  });
}
