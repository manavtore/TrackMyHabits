
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/ui/view/homeScreen.dart';
import 'package:habit_tracker/ui/view/loginPage.dart';
import 'package:habit_tracker/ui/view/newHabitScreen.dart';
import 'package:habit_tracker/ui/view/settingScreen.dart';
import 'package:habit_tracker/ui/view/signUpScreen.dart';
import 'package:habit_tracker/ui/view/statsScreen.dart';
import 'package:habit_tracker/ui/widget/habitCalender.dart';

class AppRoutes {
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String homeRoute = '/home';
  static const String newHabitRoute = '/newHabit';
  static const String settingsRoute = '/Settings';
  static const String statsRoute = '/Stats';
  static const String habitCalender = '/habitCalender';

  static final routes = {
    loginRoute: (context) => const loginScreen(),
    homeRoute: (context) => const HomeScreen(),
    newHabitRoute: (context) => const NewHabit(),
    settingsRoute:(context) => const SettingScreen(),
    statsRoute:(context) => const StatsScreen(),
    signupRoute: (context) => const SignupScreen(),
    habitCalender: (context) => HabitCalender(userId: FirebaseAuth.instance.currentUser!.uid),

 };
}