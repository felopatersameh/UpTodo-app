import 'package:flutter/material.dart';

import 'config/themes/theme.dart';
import 'features/Calendar/presentation/pages/calendar_screen.dart';
import 'features/Layout/presentation/pages/layout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: buildThemeDataDark(),
      home: LayoutScreen(),
    );
  }
}
