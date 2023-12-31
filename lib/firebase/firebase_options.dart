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
    apiKey: 'AIzaSyAhBSmCiCBMmhL1yixBGfvh9qNxfi_bEzY',
    appId: '1:162611159842:web:ae5ed8ba253e8010cbfb7b',
    messagingSenderId: '162611159842',
    projectId: 'desk-director-e22db',
    authDomain: 'desk-director-e22db.firebaseapp.com',
    storageBucket: 'desk-director-e22db.appspot.com',
    measurementId: 'G-0TDR37BZ51',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCMzfUP623mcnuO8zGN-hJebO-_RHX8GI',
    appId: '1:162611159842:android:69997dfe7c686efbcbfb7b',
    messagingSenderId: '162611159842',
    projectId: 'desk-director-e22db',
    storageBucket: 'desk-director-e22db.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcFOyskmyJLoDb-kUapSC9avg9XJ5VOxQ',
    appId: '1:162611159842:ios:0ed175d807672482cbfb7b',
    messagingSenderId: '162611159842',
    projectId: 'desk-director-e22db',
    storageBucket: 'desk-director-e22db.appspot.com',
    iosBundleId: 'com.example.deskDirector',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCcFOyskmyJLoDb-kUapSC9avg9XJ5VOxQ',
    appId: '1:162611159842:ios:b8072b3656613ecfcbfb7b',
    messagingSenderId: '162611159842',
    projectId: 'desk-director-e22db',
    storageBucket: 'desk-director-e22db.appspot.com',
    iosBundleId: 'com.example.deskDirector.RunnerTests',
  );
}
