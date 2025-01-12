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
    apiKey: 'AIzaSyDm1LylLOLRtciXam5c6NMDBwsva4KG3ws',
    appId: '1:419848928979:web:0bcbc66277ba49397f9e26',
    messagingSenderId: '419848928979',
    projectId: 'app-la-perla',
    authDomain: 'app-la-perla.firebaseapp.com',
    storageBucket: 'app-la-perla.appspot.com',
    measurementId: 'G-1KML41E13F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyADJNBNFOP77x-HmkX_lcVo1yiIPUqBiR4',
    appId: '1:419848928979:android:7c9763c0fe62eba97f9e26',
    messagingSenderId: '419848928979',
    projectId: 'app-la-perla',
    storageBucket: 'app-la-perla.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt1Tj1NO4_SgvdRddMHJ63w3946QjZYC4',
    appId: '1:419848928979:ios:eb4f258298f335407f9e26',
    messagingSenderId: '419848928979',
    projectId: 'app-la-perla',
    storageBucket: 'app-la-perla.appspot.com',
    iosClientId: '419848928979-76egmt0ajpm44h6c7boftjfbrl4m59na.apps.googleusercontent.com',
    iosBundleId: 'com.example.bestFlutterUiTemplates',
  );
}
