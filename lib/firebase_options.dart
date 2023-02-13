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
    apiKey: 'AIzaSyA4Emv9DEwfWZ49My9UiiQ_lhxFtuMBrsw',
    appId: '1:319946047250:web:be493626f53ebc908dbdcb',
    messagingSenderId: '319946047250',
    projectId: 'classmatch-f7175',
    authDomain: 'classmatch-f7175.firebaseapp.com',
    storageBucket: 'classmatch-f7175.appspot.com',
    measurementId: 'G-2CV0S971FG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfewb67yVfiV7YBMueoIqS4J0YYMtd8LM',
    appId: '1:319946047250:android:f4828afc349f8e448dbdcb',
    messagingSenderId: '319946047250',
    projectId: 'classmatch-f7175',
    storageBucket: 'classmatch-f7175.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBVWtSrwtGjVss_vQgVNYhIyve84cB-5tI',
    appId: '1:319946047250:ios:0e1f20fd03484ee18dbdcb',
    messagingSenderId: '319946047250',
    projectId: 'classmatch-f7175',
    storageBucket: 'classmatch-f7175.appspot.com',
    iosClientId: '319946047250-ukd16h3kgc0t70o6egvj7ee3cgf5jo41.apps.googleusercontent.com',
    iosBundleId: 'com.example.classmatch',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBVWtSrwtGjVss_vQgVNYhIyve84cB-5tI',
    appId: '1:319946047250:ios:0e1f20fd03484ee18dbdcb',
    messagingSenderId: '319946047250',
    projectId: 'classmatch-f7175',
    storageBucket: 'classmatch-f7175.appspot.com',
    iosClientId: '319946047250-ukd16h3kgc0t70o6egvj7ee3cgf5jo41.apps.googleusercontent.com',
    iosBundleId: 'com.example.classmatch',
  );
}