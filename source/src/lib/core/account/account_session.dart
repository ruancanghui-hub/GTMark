import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_env.dart';

/// 登录会话（SPEC-021）。
abstract final class AccountSession {
  static final signedInTick = 0.obs;

  static bool get isConfigured => SupabaseEnv.isConfigured;

  static bool get isSignedIn {
    if (!isConfigured) return false;
    return Supabase.instance.client.auth.currentSession != null;
  }

  static String? get userEmail =>
      Supabase.instance.client.auth.currentUser?.email;

  static String? get userId => Supabase.instance.client.auth.currentUser?.id;

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> signInWithEmail(String email, String password) async {
    _ensureConfigured();
    await client.auth.signInWithPassword(email: email, password: password);
    signedInTick.value++;
  }

  static Future<void> signUpWithEmail(String email, String password) async {
    _ensureConfigured();
    await client.auth.signUp(email: email, password: password);
    signedInTick.value++;
  }

  static Future<void> signOut() async {
    if (!isConfigured) return;
    await client.auth.signOut();
    signedInTick.value++;
  }

  static void _ensureConfigured() {
    if (!isConfigured) {
      throw StateError('未配置 Supabase（SUPABASE_URL / SUPABASE_ANON_KEY）');
    }
  }
}
