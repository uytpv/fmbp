import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase
  await Firebase.initializeApp();

  // Cấu hình các cổng kết nối cục bộ Firebase Emulator trong chế độ Debug
  if (kDebugMode) {
    final host = defaultTargetPlatform == TargetPlatform.android ? '10.0.2.2' : 'localhost';
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      print('Firebase Emulators connected on $host');
    } catch (e) {
      print('Error connecting to Firebase Emulators: $e');
    }
  }

  runApp(
    const ProviderScope(
      child: FMBPApp(),
    ),
  );
}

class FMBPApp extends ConsumerWidget {
  const FMBPApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Family Meal Budget Planner',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Đồng bộ với Theme hệ điều hành
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
