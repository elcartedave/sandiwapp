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
    apiKey: 'AIzaSyDO0EKoYrVw_6sv10R-6YxEACqWIAzHLPI',
    appId: '1:1014446807964:web:7b46a66579c7cca87c4659',
    messagingSenderId: '1014446807964',
    projectId: 'sandiwapp-81440',
    authDomain: 'sandiwapp-81440.firebaseapp.com',
    storageBucket: 'sandiwapp-81440.appspot.com',
    measurementId: 'G-Z1YD9VDN85',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwf8DJxElzlkNmmQhY1oHS4vM1v2Q3Ros',
    appId: '1:1014446807964:android:52f15d3fc4a938d57c4659',
    messagingSenderId: '1014446807964',
    projectId: 'sandiwapp-81440',
    storageBucket: 'sandiwapp-81440.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbWhJonJm0Q_1gVVWtY63UMZGMEZuvY2w',
    appId: '1:1014446807964:ios:4a254e9c65eb66f77c4659',
    messagingSenderId: '1014446807964',
    projectId: 'sandiwapp-81440',
    storageBucket: 'sandiwapp-81440.appspot.com',
    iosBundleId: 'com.example.sandiwapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbWhJonJm0Q_1gVVWtY63UMZGMEZuvY2w',
    appId: '1:1014446807964:ios:4a254e9c65eb66f77c4659',
    messagingSenderId: '1014446807964',
    projectId: 'sandiwapp-81440',
    storageBucket: 'sandiwapp-81440.appspot.com',
    iosBundleId: 'com.example.sandiwapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDO0EKoYrVw_6sv10R-6YxEACqWIAzHLPI',
    appId: '1:1014446807964:web:bacb7fd5a0d408b87c4659',
    messagingSenderId: '1014446807964',
    projectId: 'sandiwapp-81440',
    authDomain: 'sandiwapp-81440.firebaseapp.com',
    storageBucket: 'sandiwapp-81440.appspot.com',
    measurementId: 'G-L97EZ0KFLW',
  );
}
