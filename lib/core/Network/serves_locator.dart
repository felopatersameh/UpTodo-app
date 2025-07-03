
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/User/ViewModel/user_cubit.dart';

import '../../features/AddTask/ViewModel/AddTask/add_task_cubit.dart';
import '../../features/AddTask/model/category_model.dart';
import '../../features/AddTask/model/priority_model.dart';
import '../../features/Index/ViewModel/GetTask/get_task_cubit.dart';
import '../../features/task/ViewModel/UpdateTask/update_task_cubit.dart';
import '../model/task_model.dart';
import '../../features/User/Model/user_account_model.dart';
import '../utils/Notifications/custom_notification_manager.dart';
import '../utils/Notifications/work_manager_notification.dart';

final getIt = GetIt.instance;

Future<void> setupService() async {
  // Initial lightweight setup
  await Hive.initFlutter();
  // Register adapters
  _registerHiveAdapters();

  // Open Hive boxes
  await _openHiveBoxes();
  // Start notifications and work manager in parallel

    // Register Cubits
  _registerCubits();

  // Delete tasks from last month
  await deleteLastMonthTasks();

  await Future.wait([
    NotificationManager().initialize(),
    WorkManagerNotification().init(),
  ]);




}

void _registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(UserAccountModelAdapter().typeId)) {
    Hive.registerAdapter(UserAccountModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PriorityModelAdapter().typeId)) {
    Hive.registerAdapter(PriorityModelAdapter());
  }
}

Future<void> _openHiveBoxes() async {
  try {
    final userAccountBox = await Hive.openBox<UserAccountModel>(
      'userAccountBox',
    );
    getIt.registerSingleton<Box<UserAccountModel>>(userAccountBox);

    final taskBox = await Hive.openBox<TaskModel>('taskBox');
    getIt.registerSingleton<Box<TaskModel>>(taskBox);

    final categoryBox = await Hive.openBox<CategoryModel>('categoryBox');
    getIt.registerSingleton<Box<CategoryModel>>(categoryBox);

    final priorityBox = await Hive.openBox<PriorityModel>('priorityBox');
    getIt.registerSingleton<Box<PriorityModel>>(priorityBox);
    
    final settingsBox = await Hive.openBox<bool>('settings');
    getIt.registerSingleton<Box<bool>>(settingsBox); 

    final dateTimeBox = await Hive.openBox<double>('notificationTimeRemimmber');
    getIt.registerSingleton<Box<double>>(dateTimeBox);
  } catch (e) {
    return;
  }
}

void _registerCubits() {
  getIt.registerSingleton<GetTaskCubit>(GetTaskCubit()..getAllTasks());
  getIt.registerSingleton<UserCubit>(UserCubit()..copyAssetToLocalImage());
  getIt.registerSingleton<AddTaskCubit>(AddTaskCubit());
  getIt.registerSingleton<UpdateTaskCubit>(UpdateTaskCubit());

  // Register notification services
  getIt.registerSingleton<NotificationManager>(NotificationManager());
  getIt.registerSingleton<WorkManagerNotification>(WorkManagerNotification());
}

Future<void> deleteLastMonthTasks() async {
  final now = DateTime.now();
  final lastMonth = DateTime(
    now.year,
    now.month - 1 > 0 ? now.month - 1 : 12,
    now.day,
  );

  final taskBox = getIt<Box<TaskModel>>();
  final keysToDelete = <dynamic>[];

  for (var entry in taskBox.toMap().entries) {
    final task = entry.value;
    final key = entry.key;

    if (task.dateTime.isBefore(lastMonth)) {
      keysToDelete.add(key);
    }
  }

  if (keysToDelete.isNotEmpty) {
    await taskBox.deleteAll(keysToDelete);
  }
}
