import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/Calendar/presentation/manager/calendar_cubit.dart';

import 'config/themes/theme.dart';
import 'features/Layout/presentation/manager/app_cubit.dart';
import 'features/Layout/presentation/pages/layout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
          create: (context) => CalendarCubit()..filterToday(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: buildThemeDataDark(),
        home: const LayoutScreen(),
      ),
    );
  }
}
