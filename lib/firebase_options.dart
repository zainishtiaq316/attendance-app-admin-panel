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
    apiKey: 'AIzaSyAP8c_6DhEmphJn_HJcXj4wLpR_UcsEz0A',
    appId: '1:1008109436961:web:0504bb0d23770bcf76a360',
    messagingSenderId: '1008109436961',
    projectId: 'attendance-app-80322',
    authDomain: 'attendance-app-80322.firebaseapp.com',
    storageBucket: 'attendance-app-80322.appspot.com',
    measurementId: 'G-5RCY9F47BD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDJ-iBbIzFfy5BfvrxfVpx7yDJ2HNgfeE',
    appId: '1:1008109436961:android:db21f26807745ed276a360',
    messagingSenderId: '1008109436961',
    projectId: 'attendance-app-80322',
    storageBucket: 'attendance-app-80322.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDM1vJwpjykDr2ULoQ8Oieh6EplqAVj5yU',
    appId: '1:1008109436961:ios:94739671d9a1420976a360',
    messagingSenderId: '1008109436961',
    projectId: 'attendance-app-80322',
    storageBucket: 'attendance-app-80322.appspot.com',
    iosClientId: '1008109436961-57hl19qik1hgul5seg4svui2e4cogvn5.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendeasyadmin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDM1vJwpjykDr2ULoQ8Oieh6EplqAVj5yU',
    appId: '1:1008109436961:ios:94739671d9a1420976a360',
    messagingSenderId: '1008109436961',
    projectId: 'attendance-app-80322',
    storageBucket: 'attendance-app-80322.appspot.com',
    iosClientId: '1008109436961-57hl19qik1hgul5seg4svui2e4cogvn5.apps.googleusercontent.com',
    iosBundleId: 'com.example.attendeasyadmin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAP8c_6DhEmphJn_HJcXj4wLpR_UcsEz0A',
    appId: '1:1008109436961:web:81d4f650470809bb76a360',
    messagingSenderId: '1008109436961',
    projectId: 'attendance-app-80322',
    authDomain: 'attendance-app-80322.firebaseapp.com',
    storageBucket: 'attendance-app-80322.appspot.com',
    measurementId: 'G-S798NSYDNY',
  );
}
