import 'package:flutter/material.dart';
import '../../core/utils/resource/colors.dart';
import '../../core/utils/resource/styles.dart';

ThemeData buildThemeDataDark(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppColors.backGroundColor,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: Styles.text20AppBar(),
      backgroundColor: AppColors.backGroundColor,
    ),
    datePickerTheme: DatePickerThemeData(
        confirmButtonStyle: ButtonStyle(
            textStyle: WidgetStatePropertyAll(Styles.text16()),
            backgroundColor: WidgetStatePropertyAll(AppColors.primaryColor))),
    scaffoldBackgroundColor: AppColors.backGroundColor,
  );
}
