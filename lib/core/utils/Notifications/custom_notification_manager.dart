import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../Network/serves_locator.dart';
import '../../model/notification_action.dart';

@pragma('vm:entry-point')
void _onNotificationTap(NotificationResponse? response) {
  final String? payload = response?.payload;

  if (payload != null) {
    // Send payload to the stream
    NotificationManager.notificationStreamController.add(response);

    // Add additional logic, e.g., navigation:
    // log('Notification clicked with payload: $payload');
  }
}

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() => _instance;

  NotificationManager._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _defaultChannelId = 'Initiative';
  static const String _defaultChannelName = 'UpToDo Notifications';
  static const String _defaultChannelDescription = 'TO Do App Tasks Higher ';

  static double getTimeReminder() {
    final notificationTimeReminderBox = getIt.get<Box<double>>();
    final double notificationTimeReminder =
        notificationTimeReminderBox.get(
          'notificationTimeReminder',
          defaultValue: 15,
        ) ??
        15;
    return notificationTimeReminder;
  }

  static final StreamController<NotificationResponse?>
  notificationStreamController = StreamController.broadcast();

  // Expose notification stream for app-wide access
  Stream<NotificationResponse?> get notificationStream =>
      notificationStreamController.stream;

  Future<void> initialize() async {
    final settingsBox = getIt.get<Box<bool>>();
    final isNotificationPermissionGranted = settingsBox.get(
      'isNotificationPermissionGranted',
      defaultValue: null,
    );
    if (isNotificationPermissionGranted == false) {
      return;
    }
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTap,
    );

    await createNotificationChannel(
      channelId: _defaultChannelId,
      channelName: _defaultChannelName,
      channelDescription: _defaultChannelDescription,
    );
    await requestNotificationPermission();
    // log("NotificationManager Initialized");
  }

  Future<void> requestNotificationPermission() async {
    if (!Platform.isAndroid) {
      return;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final androidVersion = androidInfo.version.release;

    // Request notification permission
    final notificationStatus = await Permission.notification.request();

    // Handle permission status
    if (notificationStatus.isGranted) {
      final settingsBox = getIt.get<Box<bool>>();
      await settingsBox.put('isNotificationPermissionGranted', true);
      return;
    }
    // } else if (notificationStatus.isDenied) {
    //   log("Notification permission denied. Notifications may not work properly.");
    // } else
    if (notificationStatus.isPermanentlyDenied) {
      final settingsBox = getIt.get<Box<bool>>();
      await settingsBox.put('isNotificationPermissionGranted', false);
      await openAppSettings();
    }

    // Request additional permissions for Android 31 and 32
    if (androidVersion.compareTo('31') >= 0 &&
        androidVersion.compareTo('32') <= 0) {
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      if (alarmStatus.isPermanentlyDenied) {
        // log("Exact Alarm permission permanently denied. Redirecting to settings...");
        await openAppSettings();
      }
    }
  }

  Future<void> createNotificationChannel({
    required String channelId,
    required String channelName,
    String? channelDescription,
    Importance importance = Importance.high,
  }) async {
    final AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: importance,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Show notification with image [DONE]
  Future<void> showNotificationNow({
    int id = 0,
    required String title,
    required String body,
    String? imageUrl,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    // Check if image is provided
    final styleInformation = imageUrl != null
        ? BigPictureStyleInformation(
            FilePathAndroidBitmap(imageUrl),
            largeIcon: FilePathAndroidBitmap(imageUrl),
            contentTitle: title,
            summaryText: body,
          )
        : null; // Default style if no image

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      styleInformation: styleInformation,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
    // log('Send');
  }

  // Show interactive notification [DONE]
  Future<void> showInteractiveNotification({
    required int id,
    required String title,
    required String body,
    required List<NotificationAction> actions,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    final List<AndroidNotificationAction> androidActions = actions
        .map((action) => AndroidNotificationAction(action.id, action.title))
        .toList();

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.high,
      priority: Priority.high,
      actions: androidActions,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  Future<void> showScheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    try {
      tz.setLocalLocation(tz.getLocation("Africa/Cairo"));
      final now = tz.TZDateTime.now(tz.local);

      // Calculate the next occurrence of the specified time
      tz.TZDateTime scheduledTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If the time has already passed today, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            category: AndroidNotificationCategory.reminder,
            enableVibration: true,
            enableLights: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: payload ?? 'daily_reminder',
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

    } catch (e) {
      return;
    }
  }

  // Grouped Notifications
  Future<void> showGroupedNotification({
    required int groupId,
    required String groupKey,
    required List<Map<String, String>> notifications,
    String summaryTitle = 'Summary',
    String summaryBody = 'You have new notifications',
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    for (int i = 0; i < notifications.length; i++) {
      final notification = notifications[i];
      await _flutterLocalNotificationsPlugin.show(
        groupId + i,
        notification['title']!,
        notification['body']!,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            groupKey: groupKey,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }

    // Summary Notification
    await _flutterLocalNotificationsPlugin.show(
      groupId,
      summaryTitle,
      summaryBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          groupKey: groupKey,
          setAsGroupSummary: true,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleSingleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    final notificationTimeReminder = getTimeReminder();
    tz.setLocalLocation(tz.getLocation("Africa/Cairo"));
    final DateTime notificationTime = scheduledTime.subtract(
      Duration(minutes: notificationTimeReminder.toInt()),
    );
    if (notificationTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      notificationTime.year,
      notificationTime.month,
      notificationTime.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          category: AndroidNotificationCategory.reminder,
        ),
      ),
      payload: payload,

      // uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Schedule notification for a specific task
  Future<void> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime taskDateTime,
    String? payload,
    String channelId = _defaultChannelId,
    String channelName = _defaultChannelName,
  }) async {
    try {
      tz.setLocalLocation(tz.getLocation("Africa/Cairo"));

      // Schedule notification 15 minutes before task
      final DateTime notificationTime = taskDateTime.subtract(
        const Duration(minutes: 15),
      );

      // Don't schedule if the time has already passed
      if (notificationTime.isBefore(DateTime.now())) {
        return;
      }

      final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        notificationTime,
        tz.local,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            category: AndroidNotificationCategory.reminder,
            enableVibration: true,
            enableLights: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: payload,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      return;
    }
  }

  /// Schedule multiple notifications for a task (e.g., 1 hour before, 15 minutes before)
  Future<void> scheduleMultipleTaskNotifications({
    required int baseId,
    required String title,
    required String body,
    required DateTime taskDateTime,
    String? payload,
    List<Duration> reminderTimes = const [
      Duration(hours: 1),
      Duration(minutes: 15),
    ],
  }) async {
    for (int i = 0; i < reminderTimes.length; i++) {
      final reminderTime = reminderTimes[i];
      final notificationTime = taskDateTime.subtract(reminderTime);

      if (notificationTime.isAfter(DateTime.now())) {
        await scheduleTaskNotification(
          id: baseId + i,
          title: title,
          body: body,
          taskDateTime: taskDateTime,
          payload: payload,
        );
      }
    }
  }
}

// Helper class for actions
