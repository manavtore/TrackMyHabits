import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/core/app/provider.dart';
import 'package:habit_tracker/features/notification/notification.service.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:habit_tracker/features/routes/routes.dart';
import 'package:habit_tracker/firebase_options.dart';
import 'package:habit_tracker/ui/view/loginPage.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  tz.initializeTimeZones();
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
      initialRoute: AppRoutes.loginMeta,
      routes: AppRoutes.routes,
     
    );
  }
}
