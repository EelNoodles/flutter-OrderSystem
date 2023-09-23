// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAW-aDctn0DVE8nISWB509B_G7dPCZX64g',
    appId: '1:787128229100:android:d7eed8c9234e2d0c46d9c9',
    messagingSenderId: '787128229100',
    projectId: 'helloflutter-27b47',
    databaseURL: 'https://helloflutter-27b47-default-rtdb.firebaseio.com',
    storageBucket: 'helloflutter-27b47.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrAPmOn-pt91irBsSO5pKO68-fz09_z1s',
    appId: '1:787128229100:ios:20388874a54f493746d9c9',
    messagingSenderId: '787128229100',
    projectId: 'helloflutter-27b47',
    databaseURL: 'https://helloflutter-27b47-default-rtdb.firebaseio.com',
    storageBucket: 'helloflutter-27b47.appspot.com',
    androidClientId: '787128229100-qs967ulk19mfgt1gr7stnsrvhr9piega.apps.googleusercontent.com',
    iosClientId: '787128229100-76rfnt6c01k3igb58nk12vccnn9h1kg5.apps.googleusercontent.com',
    iosBundleId: 'com.example.helloWorld',
  );
}