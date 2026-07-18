import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/family/presentation/onboarding_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../core/services/firebase_auth_service.dart';
import '../core/services/firestore_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStream = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
    redirect: (context, state) async {
      final user = authStream.value;
      
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      // 1. Nếu chưa đăng nhập: đi tới đăng nhập (hoặc đăng ký)
      if (user == null) {
        if (isLoggingIn || isRegistering) return null;
        return '/login';
      }

      // 2. Nếu đã đăng nhập, kiểm tra người dùng đã tham gia gia đình chưa
      if (isLoggingIn || isRegistering) {
        // Lấy thông tin user document từ Firestore
        final userDoc = await ref.read(firestoreServiceProvider).watchUser(user.uid).first;
        if (userDoc == null || userDoc.familyId == null) {
          return '/onboarding';
        }
        return '/dashboard';
      }

      return null;
    },
  );
});
