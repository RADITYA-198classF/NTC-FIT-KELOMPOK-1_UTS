import 'package:flutter/material.dart';

import '../screens/auth/email_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/signin_success_screen.dart';
import '../screens/onboarding/frequency_screen.dart';
import '../screens/onboarding/gender_screen.dart';
import '../screens/onboarding/library_loading_screen.dart';
import '../screens/onboarding/member_welcome_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/shell/main_shell.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/welcome/welcome_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String authEmail = '/auth/email';
  static const String authRegister = '/auth/register';
  static const String authSuccess = '/auth/success';
  static const String memberWelcome = '/onboarding/welcome';
  static const String gender = '/onboarding/gender';
  static const String frequency = '/onboarding/frequency';
  static const String loading = '/onboarding/loading';
  static const String main = '/main';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final Widget page;
    switch (routeSettings.name) {
      case welcome:
        page = const WelcomeScreen();
        break;
      case authEmail:
        page = const EmailScreen();
        break;
      case authRegister:
        page = const RegisterScreen();
        break;
      case authSuccess:
        page = const SigninSuccessScreen();
        break;
      case memberWelcome:
        page = const MemberWelcomeScreen();
        break;
      case gender:
        page = const GenderScreen();
        break;
      case frequency:
        page = const FrequencyScreen();
        break;
      case loading:
        page = const LibraryLoadingScreen();
        break;
      case main:
        page = const MainShell();
        break;
      case settings:
        page = const SettingsScreen();
        break;
      case profile:
        page = const ProfileScreen();
        break;
      case splash:
      default:
        page = const SplashScreen();
    }
    return MaterialPageRoute<void>(
      builder: (BuildContext context) => page,
      settings: routeSettings,
    );
  }
}
