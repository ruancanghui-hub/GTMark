/// Supabase 运行时配置（编译期 `--dart-define` 注入，勿提交密钥）。
abstract final class SupabaseEnv {
  static const url = String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const anonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static bool get isConfigured => url.isNotEmpty && anonKey.isNotEmpty;
}
