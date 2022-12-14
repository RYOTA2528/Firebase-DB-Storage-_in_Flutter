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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDggEhmA_krZFG9l0rK_xz2tVu-r0tSxd4',
    appId: '1:392783968653:web:2a0e153439cb4dc412e5c4',
    messagingSenderId: '392783968653',
    projectId: 'fir-project-app-7aa0a',
    authDomain: 'fir-project-app-7aa0a.firebaseapp.com',
    storageBucket: 'fir-project-app-7aa0a.appspot.com',
    measurementId: 'G-KMC23FJ0PR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBiAQD_y5lzr2cCO63L_KAOzbQYZlvjEKM',
    appId: '1:392783968653:android:42500eff528968ca12e5c4',
    messagingSenderId: '392783968653',
    projectId: 'fir-project-app-7aa0a',
    storageBucket: 'fir-project-app-7aa0a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCPOQKZnPl5t4o-P2vUUBj6fP2JCBqbhw8',
    appId: '1:392783968653:ios:3d43ef71f47e062612e5c4',
    messagingSenderId: '392783968653',
    projectId: 'fir-project-app-7aa0a',
    storageBucket: 'fir-project-app-7aa0a.appspot.com',
    iosClientId: '392783968653-8vlmvnrorp7e5n29e5v2ng0bobbnj43h.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebase',
  );
}
