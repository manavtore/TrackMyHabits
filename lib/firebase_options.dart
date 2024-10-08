// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB2BGwWx7mc6TkO1dYdGHoKBuWJzsXKC34',
    appId: '1:171242316755:web:3b5ad0215547776bb28526',
    messagingSenderId: '171242316755',
    projectId: 'habittracker-e6465',
    authDomain: 'habittracker-e6465.firebaseapp.com',
    storageBucket: 'habittracker-e6465.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoBq1P2jFwchdPlBQMzlGdajD_1AiU2JY',
    appId: '1:171242316755:android:0312744adf44797ab28526',
    messagingSenderId: '171242316755',
    projectId: 'habittracker-e6465',
    storageBucket: 'habittracker-e6465.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyApTB4ys1a-I1bdmn4i3M1UfLT7k-_n6n4',
    appId: '1:171242316755:ios:34a5e7e45ac1eeadb28526',
    messagingSenderId: '171242316755',
    projectId: 'habittracker-e6465',
    storageBucket: 'habittracker-e6465.appspot.com',
    iosBundleId: 'com.example.habitTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyApTB4ys1a-I1bdmn4i3M1UfLT7k-_n6n4',
    appId: '1:171242316755:ios:34a5e7e45ac1eeadb28526',
    messagingSenderId: '171242316755',
    projectId: 'habittracker-e6465',
    storageBucket: 'habittracker-e6465.appspot.com',
    iosBundleId: 'com.example.habitTracker',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2BGwWx7mc6TkO1dYdGHoKBuWJzsXKC34',
    appId: '1:171242316755:web:179d45b6346bd4fdb28526',
    messagingSenderId: '171242316755',
    projectId: 'habittracker-e6465',
    authDomain: 'habittracker-e6465.firebaseapp.com',
    storageBucket: 'habittracker-e6465.appspot.com',
  );

}