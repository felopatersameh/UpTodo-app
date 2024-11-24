import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'features/task/ViewModel/UpdateTask/update_task_cubit.dart';
import 'core/Network/serves_locator.dart';
import 'features/Index/ViewModel/GetTask/get_task_cubit.dart';
import 'features/AddTask/ViewModel/AddTask/add_task_cubit.dart';

import 'config/themes/theme.dart';
import 'features/Layout/View/Pages/layout_screen.dart';
import 'features/User/ViewModel/user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupService();
  // Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<GetTaskCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<AddTaskCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<UpdateTaskCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        enableScaleWH: () => false,
        enableScaleText: () => false,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            darkTheme: buildThemeDataDark(context),
            home: const LayoutScreen(),
          );
        },
      ),
    );
  }
}
