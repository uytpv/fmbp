import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/firestore_service.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Stream<fb.User?> build() {
    return ref.watch(firebaseAuthServiceProvider).authStateChanges;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await ref.read(firebaseAuthServiceProvider).signInWithEmail(
            email: email,
            password: password,
          );
      if (credential.user != null) {
        await ref.read(firestoreServiceProvider).ensureUserDocument(
              credential.user!.uid,
              credential.user!.email ?? email,
            );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await ref.read(firebaseAuthServiceProvider).signUpWithEmail(
            email: email,
            password: password,
          );
      if (credential.user != null) {
        await ref.read(firestoreServiceProvider).ensureUserDocument(
              credential.user!.uid,
              credential.user!.email ?? email,
            );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(firebaseAuthServiceProvider).signOut();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
