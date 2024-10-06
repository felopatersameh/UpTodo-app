import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/Network/serves_locator.dart';
import 'features/TaskManagement/ViewModel/AddTask/add_task_cubit.dart';

import 'config/themes/theme.dart';
import 'features/Layout/View/Pages/layout_screen.dart';
import 'features/User/ViewModel/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddTaskCubit()..filter(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
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
