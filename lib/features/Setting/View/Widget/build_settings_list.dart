
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

import '../../../../core/utils/resource/colors.dart';
import '../../../../core/utils/resource/icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../User/View/Widget/build_ui_setting_account_screen_dialog.dart';
import '../../../User/View/Widget/change_time_remember.dart';
import '../../ViewModel/setting_cubit.dart';

class BuildSettingsList extends StatelessWidget {
  const BuildSettingsList({super.key});

  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => SettingCubit()..init(),
      child: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          return state.isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : SettingsList(
                  applicationType: ApplicationType.material,
                  platform: DevicePlatform.android,
                  darkTheme: _buildSettingsThemeData(),
                  lightTheme: _buildSettingsThemeData(),
                  sections: [
                    // SettingsSection(
                    //   title: Text(
                    //     'security',
                    //     style: Styles.text14().copyWith(
                    //       color: AppColors.gray1TextColor,
                    //     ),
                    //   ),
                    //   tiles: [
                    //     SettingsTile.switchTile(
                    //       onToggle: (value) async {},
                    //       initialValue: false,
                    //       leading: Icon(Icons.password),
                    //       title: Text(
                    //         'Enable Password Lock',
                    //         style: Styles.text16(),
                    //       ),
                    //     ),
                    //     SettingsTile.switchTile(
                    //       onToggle: (value) async {},
                    //       initialValue: false,
                    //       leading: Icon(Icons.face),
                    //       title: Text('Face Unlock'),
                    //     ),
                    //     SettingsTile.switchTile(
                    //       onToggle: (value) {},
                    //       leading: Icon(Icons.fingerprint),
                    //       title: Text('Finger Unlock'),
                    //       onPressed: (context) {},
                    //       initialValue: false,
                    //     ),
                    //   ],
                    // ),
                    SettingsSection(
                      title: Text('Settings'),
                      tiles: [
                        SettingsTile.switchTile(
                          onToggle: (value) async {
                            await context
                                .read<SettingCubit>()
                                .dailyReminder(value);
                          },
                          initialValue: state.isReminder ?? false,
                          leading: Icon(Icons.notifications),
                          title: Text('Cancel Notification Daily reminder'),
                        ),
                        SettingsTile.switchTile(
                          onToggle: (value) async {
                            await context
                                .read<SettingCubit>()
                                .allNotifications( value);
                          },
                          initialValue: state.isAllowedALl ?? false,
                          leading: Icon(Icons.notifications),
                          title: Text('Cancel All Notification'),
                        ),
                        SettingsTile.navigation(
                          leading: Icon(Icons.notifications),
                          title: Text('Edit Time Notification'),
                          trailing: AppIcons.arrowForward,
                          onPressed: (context) {
                            showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return BuildUiSettingAccount(
                      itemModel:ChangeTimeRemember(),
                    );
                  },
                );
                            
                          },
                        ),
                       
                      ],
                    ),
                    SettingsSection(
                      title: Text('Backup & Restore'),
                      tiles: [
                        SettingsTile.navigation(
                          onPressed: (context) {},
                          leading: Icon(Icons.notifications),
                          title: Text('Import Backup'),
                          trailing: AppIcons.arrowForward,
                        ),
                        SettingsTile.navigation(
                          leading: Icon(Icons.notifications),
                          title: Text('Export Backup'),
                          trailing: AppIcons.arrowForward,
                          onPressed: (context) async {
                            // final nameUser =  getIt<Box<UserAccountModel>>().name;
                            // final time =
                            //     DateFormat('yyyy-MM-dd').format(DateTime.now());
                            // await AppDataExport.exportData(
                            //     'backup[$nameUser] - $time.json');
                          },
                        ),
                      ],
                    ),
                  ],
                );
        },
      ),
    );
  }

  SettingsThemeData _buildSettingsThemeData() => SettingsThemeData(
    settingsListBackground: AppColors.backGroundColor,
    settingsSectionBackground: AppColors.backGroundColor,
    inactiveSubtitleColor: AppColors.primaryColor,
    leadingIconsColor: AppColors.iconColor,
    titleTextColor: AppColors.gray1TextColor,
    settingsTileTextColor: AppColors.textColor,
    tileHighlightColor: AppColors.backGroundColor,
    inactiveTitleColor: AppColors.backGroundColor,
    tileDescriptionTextColor: AppColors.gray2TextColor,
  );
}
