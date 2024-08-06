import 'package:flutter/material.dart';
import 'package:habit_tracker/core/app/provider.dart';

import 'package:habit_tracker/features/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracker/ui/view/homeScreen.dart';
import 'package:habit_tracker/ui/view/loginPage.dart';
import 'package:habit_tracker/ui/view/signUpScreen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Core());
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.provider,
      child: const HabitTracker(),
    );
  }
}

class HabitTracker extends StatelessWidget {
  const HabitTracker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.homeRoute,
      routes: AppRoutes.routes,
      home: const Scaffold(
        body: Center(
          child:HomeScreen()

        ),
      ),
    );
  }
}
