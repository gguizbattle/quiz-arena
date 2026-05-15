import 'package:supabase_flutter/supabase_flutter.dart';

/// Bütün auth axını Supabase Auth üzərindən gedir.
/// Backend token verifikasiyası üçün Supabase JWT istifadə edir.
/// Bu sinif sadəcə wrap-dır ki, çağırışlar bir yerdə cəmlənsin.
class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  bool get isLoggedIn => _client.auth.currentSession != null;

  User? get currentUser => _client.auth.currentUser;

  String? get accessToken => _client.auth.currentSession?.accessToken;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Email/şifrə ilə qeydiyyat. Supabase `auth.users`-da hesab yaradır
  /// və DB trigger avtomatik `public.users`-da profil yaradır.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: {'username': username},
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Native Google sign-in: mobile tərəfdə idToken alınır,
  /// sonra Supabase-ə ötürülür. Web/Server flow yox, native One Tap variantı.
  Future<AuthResponse> signInWithGoogleIdToken({
    required String idToken,
    String? accessToken,
    String? nonce,
  }) {
    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
      nonce: nonce,
    );
  }

  Future<AuthResponse> signInWithAppleIdToken({
    required String idToken,
    String? nonce,
  }) {
    return _client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: nonce,
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
