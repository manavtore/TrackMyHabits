// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initialize() async {
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     String? token = await _firebaseMessaging.getToken();
//     print('Device Token: $token');


//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message received: ${message.notification?.title}');

//       if (message.notification != null) {
//         print('Message Title: ${message.notification!.title}');
//         print('Message Body: ${message.notification!.body}');
//       }
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     print('Handling a background message: ${message.messageId}');
//   }
// }
