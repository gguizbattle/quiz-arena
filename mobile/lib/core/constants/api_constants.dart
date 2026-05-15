class ApiConstants {
  ApiConstants._();

  /// Public Railway backend URL.
  static const String backendUrl = 'https://quiz-arena-backend-production.up.railway.app';
  static const String wsUrl = 'wss://quiz-arena-backend-production.up.railway.app';

  static const String baseUrl = '$backendUrl/api/v1';
  static const String socketUrl = '$wsUrl/game';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  /// Supabase (auth + DB)
  static const String supabaseUrl = 'https://odjfodvdrmcmdsollhfk.supabase.co';

  /// Public anon/publishable key — embedded olur, təhlükəsizdir.
  /// Yeni format: `sb_publishable_...` (köhnə JWT-anon yerinə).
  static const String supabaseAnonKey = 'sb_publishable_cAjQEVUt7EXhqYajHT2g5Q_o6BrLUlm';

  /// Google OAuth Web Client ID — Supabase Auth-da signInWithIdToken üçün lazımdır
  /// ki, returned idToken-in `aud` claim-i bu ID ilə uyğun gəlsin.
  static const String googleWebClientId =
      '142040296065-e829bp8tj6vi0fk7eimh94lvgbi941mo.apps.googleusercontent.com';
}
