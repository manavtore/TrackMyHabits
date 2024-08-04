
import 'package:habit_tracker/ui/view/homeScreen.dart';
import 'package:habit_tracker/ui/view/loginPage.dart';
import 'package:habit_tracker/ui/view/newHabit.dart';
import 'package:habit_tracker/ui/view/settingScreen.dart';
import 'package:habit_tracker/ui/view/signUpScreen.dart';
import 'package:habit_tracker/ui/view/statsScreen.dart';

class AppRoutes {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String newHabitRoute = '/newHabit';
  static const String settingsRoute = '/Settings';
  static const String statsRoute = '/Stats';

  static final routes = {
    loginRoute: (context) => const loginScreen(),
    homeRoute: (context) => const HomeScreen(),
    newHabitRoute: (context) => const newHabit(),
    settingsRoute:(context) => const SettingScreen(),
    statsRoute:(context) => const StatsScreen(),
    signupRoute: (context) => const SignupScreen(),   
  };
}
