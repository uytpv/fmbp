import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Cấu hình Firebase mặc định cho môi trường phát triển cục bộ và Firebase Emulator.
/// Sử dụng project id 'demo-fmbp' tương thích với Firebase Emulator Suite.
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
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:web:demo',
    messagingSenderId: '123456789',
    projectId: 'demo-fmbp',
    authDomain: 'demo-fmbp.firebaseapp.com',
    storageBucket: 'demo-fmbp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:android:demo',
    messagingSenderId: '123456789',
    projectId: 'demo-fmbp',
    storageBucket: 'demo-fmbp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:123456789:ios:demo',
    messagingSenderId: '123456789',
    projectId: 'demo-fmbp',
    storageBucket: 'demo-fmbp.appspot.com',
    iosBundleId: 'app.mealsave.mobile',
  );
}
