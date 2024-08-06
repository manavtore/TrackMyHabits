
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

 static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

 static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async{
   print('Notification Received');
 }

 static Future<void> init() async{
  const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/aizen");

  const DarwinInitializationSettings IOSInitializationSettings = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: IOSInitializationSettings
  );


  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    onDidReceiveNotificationResponse: onDidReceiveNotification,
    );


await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  

 }

 static Future<void> showInstantNotification(String title,String body )async {
 
          const NotificationDetails notificationDetails = NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_Id',
              'channel_name',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            )
            
          );
          await flutterLocalNotificationsPlugin.show(
            0,
            title,
            body,
            notificationDetails,
            payload: 'payload',
          );
 }  

  static Future<void> showScheduledNotification(String title, String body,DateTime scheduleDatetime) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_Id',
          'channel_name',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduleDatetime, tz.local),
      const NotificationDetails(
          iOS: DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            'reminder_channel',
            'Reminder Channel',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
  } 


}