import 'package:flutter/material.dart';
import '../../features/Calendar/View/Pages/calendar_screen.dart';
import '../../features/Focus/focus_screen.dart';
import '../../features/Index/View/Pages/index_screen.dart';
import '../../features/Setting/setting_screen.dart';
import '../../features/User/View/Pages/user_screen.dart';

import '../../core/utils/Widget/image_view.dart';
import '../../features/Layout/View/Pages/layout_screen.dart';

class AppRoutes {
  // static const String splash = '/';
  // static const String onboarding = 'onboarding/';
  // static const String loginScreen = 'login_screen/';
  // static const String registerScreen = 'register_screen/';
  // static const String forgotPassword = 'forgot_password_screen/';
  // static const String otpScreen = 'otp_screen/';
  // static const String createNewPassword = 'create_new_password_screen/';
  // static const String passwordChanged = 'password_changed_screen/';
  static const String homeScreen = 'homeScreen/';
  static const String accountScreen = 'account_screen/';
  static const String accountSettingsScreen = 'account_settings_screen/';
  static const String index = 'index/';
  static const String calender = 'calender/';
  static const String focus = 'focus/';
  static const String imageView = 'image_view/';

  static final Map<String, WidgetBuilder> routeBuilders = {
    // splash: (_) => const MyCustomSplashScreen(),
    // onboarding: (_) => const IntroScreen(),
    // loginScreen: (_) => const LoginScreen(),
    // registerScreen: (_) => const RegisterScreen(),
    // forgotPassword: (_) => const ForgotPasswordScreen(),
    // otpScreen: (_) => const OtpVerificationScreen(),
    // createNewPassword: (_) => const CreateNewPasswordScreen(),
    // passwordChanged: (_) => const PasswordChanged(),
    homeScreen: (_) => const LayoutScreen(),
    index: (_) => const IndexScreen(),
    calender: (_) => const CalendarScreen(),
    focus: (_) => const FocusScreen(),
    accountScreen: (_) => const UserScreen(),
    accountSettingsScreen: (_) => const SettingScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final builder = routeBuilders[settings.name];

    if (settings.name == imageView) {
      final args = settings.arguments as String;
      return PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => ImageView(
          photo: args,
        ),
      );
    } else if (builder != null) {
      return MaterialPageRoute(builder: builder);
    }

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page not found')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
