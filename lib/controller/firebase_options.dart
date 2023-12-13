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
    apiKey: 'AIzaSyDJVBWtro6ESFoP-IhnYdYPcRl8F-aeroM',
    appId: '1:777828898569:web:95139c3ccd70f020b5a5d8',
    messagingSenderId: '777828898569',
    projectId: 'believercomma',
    authDomain: 'believercomma.firebaseapp.com',
    storageBucket: 'believercomma.appspot.com',
    measurementId: 'G-6R0T380Q8L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5_vY9MWglILO4MsgggWwv14AAS_gS6Ps',
    appId: '1:777828898569:android:e7d38617d6b1496fb5a5d8',
    messagingSenderId: '777828898569',
    projectId: 'believercomma',
    storageBucket: 'believercomma.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBV_HczZWdeA9x6tdspGoVD9A8sXT0RBEg',
    appId: '1:777828898569:ios:3c24661abb8d707cb5a5d8',
    messagingSenderId: '777828898569',
    projectId: 'believercomma',
    storageBucket: 'believercomma.appspot.com',
    androidClientId: '777828898569-k8hs3kslohvv639ahd91il6eqe32fkql.apps.googleusercontent.com',
    iosClientId: '777828898569-gfqanbkbeuc2tjc02526lmes7kdf9eqm.apps.googleusercontent.com',
    iosBundleId: 'com.comma.believer',
  );
}
