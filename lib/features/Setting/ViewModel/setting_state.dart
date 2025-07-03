part of 'setting_cubit.dart';

@immutable
class SettingState {
  final bool? isReminder;
  final bool? isAllowedALl;
  final bool? isLoading;

  const SettingState({this.isReminder, this.isAllowedALl, this.isLoading});

  SettingState copyWith({
    bool? isReminder,
    bool? isAllowedALl,
    bool? isLoading,
  }) {
    return SettingState(
      isReminder: isReminder ?? this.isReminder,
      isAllowedALl: isAllowedALl ?? this.isAllowedALl,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
