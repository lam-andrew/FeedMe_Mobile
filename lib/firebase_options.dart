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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRHvRZ700W9ArQeRxlBrfovoutodOuPH0',
    appId: '1:946423296668:web:382bb18ada1c2b16863359',
    messagingSenderId: '946423296668',
    projectId: 'feedmemobile-d94b1',
    authDomain: 'feedmemobile-d94b1.firebaseapp.com',
    storageBucket: 'feedmemobile-d94b1.appspot.com',
    measurementId: 'G-3TGWH531J5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYfbA_0vGrnbuyGpWe-3ouHOffXz3bupA',
    appId: '1:946423296668:android:d0edb6ff6ab45c64863359',
    messagingSenderId: '946423296668',
    projectId: 'feedmemobile-d94b1',
    storageBucket: 'feedmemobile-d94b1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAGN9RMH5P32gKARZ6ZqNeRRQrVmYtV560',
    appId: '1:946423296668:ios:6966d65e9c2eed47863359',
    messagingSenderId: '946423296668',
    projectId: 'feedmemobile-d94b1',
    storageBucket: 'feedmemobile-d94b1.appspot.com',
    iosClientId: '946423296668-e4nk9261dgaul11ba89d5rrg064e77q0.apps.googleusercontent.com',
    iosBundleId: 'com.andrewlam.feedmeMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAGN9RMH5P32gKARZ6ZqNeRRQrVmYtV560',
    appId: '1:946423296668:ios:6966d65e9c2eed47863359',
    messagingSenderId: '946423296668',
    projectId: 'feedmemobile-d94b1',
    storageBucket: 'feedmemobile-d94b1.appspot.com',
    iosClientId: '946423296668-e4nk9261dgaul11ba89d5rrg064e77q0.apps.googleusercontent.com',
    iosBundleId: 'com.andrewlam.feedmeMobile',
  );
}