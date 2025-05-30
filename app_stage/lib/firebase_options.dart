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
    apiKey: 'AIzaSyCEODGfsHEO9vEMAFj8UKFiMWzKJIO_JJU',
    appId: '1:120009438474:web:1aefe03b010f4c8391f6f3',
    messagingSenderId: '120009438474',
    projectId: 'myappauth-8957a',
    authDomain: 'myappauth-8957a.firebaseapp.com',
    storageBucket: 'myappauth-8957a.firebasestorage.app',
    measurementId: 'G-1G190R2BVW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAG7Rc09WujDSnAqz512Am99lUw-guBLss',
    appId: '1:120009438474:android:70c708122f40274d91f6f3',
    messagingSenderId: '120009438474',
    projectId: 'myappauth-8957a',
    storageBucket: 'myappauth-8957a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCX5qaPrNrBtauz1YOk6GXdsyle6xvYa4A',
    appId: '1:120009438474:ios:099f1cf58f11f53391f6f3',
    messagingSenderId: '120009438474',
    projectId: 'myappauth-8957a',
    storageBucket: 'myappauth-8957a.firebasestorage.app',
    iosBundleId: 'com.example.appStage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCX5qaPrNrBtauz1YOk6GXdsyle6xvYa4A',
    appId: '1:120009438474:ios:099f1cf58f11f53391f6f3',
    messagingSenderId: '120009438474',
    projectId: 'myappauth-8957a',
    storageBucket: 'myappauth-8957a.firebasestorage.app',
    iosBundleId: 'com.example.appStage',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCEODGfsHEO9vEMAFj8UKFiMWzKJIO_JJU',
    appId: '1:120009438474:web:42f4b8ad8641425a91f6f3',
    messagingSenderId: '120009438474',
    projectId: 'myappauth-8957a',
    authDomain: 'myappauth-8957a.firebaseapp.com',
    storageBucket: 'myappauth-8957a.firebasestorage.app',
    measurementId: 'G-ZJGZQ6D9EC',
  );
}
