
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:workmanager/workmanager.dart';
import 'package:hive/hive.dart';

import '../../../core/Network/serves_locator.dart';
import '../../../core/utils/Notifications/custom_notification_manager.dart';
import '../../../core/utils/Notifications/work_manager_notification.dart';

part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit() : super(const SettingState());

  void init() async {
    emit(state.copyWith(isLoading: true));
    final settingsBox = getIt.get<Box<bool>>();
    final bool? isNotificationPermissionGranted = settingsBox.get('isNotificationPermissionGranted', defaultValue: false);
    final bool? isWorkManagerActive = settingsBox.get('isWorkManagerActive', defaultValue: false);
    final bool isCancelAll = isNotificationPermissionGranted == true && isWorkManagerActive == true;
    emit(
      state.copyWith(
        isReminder: isWorkManagerActive,
        isAllowedALl: isCancelAll,
        isLoading: false,
      ),
    );
  }

  

  Future<void> allNotifications(bool isAlowedALl) async {
    final settingsBox = getIt.get<Box<bool>>();
    if (!isAlowedALl) {
      await Workmanager().cancelAll();
      await NotificationManager().cancelAllNotifications();
    } else if (isAlowedALl == true) {
      await WorkManagerNotification().init();
      await NotificationManager().initialize();
    }

    await settingsBox.put('isWorkManagerActive', isAlowedALl);
    await settingsBox.put('isNotificationPermissionGranted', isAlowedALl);
    emit(
      state.copyWith(
        isReminder: isAlowedALl,
        isAllowedALl: isAlowedALl,
        isLoading: false,
      ),
    );
  }

  Future<void> dailyReminder(bool isDailyReminder) async {
    final settingsBox = getIt.get<Box<bool>>();
    if (!isDailyReminder) {
      await Workmanager().cancelAll();
    } else if (isDailyReminder == true) {
      await WorkManagerNotification().init();
    }
    await settingsBox.put('isWorkManagerActive', true);
    await settingsBox.put('isNotificationPermissionGranted', true);
    emit(state.copyWith(isReminder: isDailyReminder, isLoading: false));
  }
}
