import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/providers/app_providers.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? username;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.username,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, String? username, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      username: username ?? this.username,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final repo = ref.watch(authRepositoryProvider);
    final loggedIn = await repo.isLoggedIn();
    final storage = ref.watch(storageProvider);
    final username = await storage.read(key: 'username');
    return AuthState(
      status: loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
      username: username,
    );
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.login(identifier: identifier, password: password);
      final storage = ref.read(storageProvider);
      final username = await storage.read(key: 'username');
      state = AsyncData(AuthState(status: AuthStatus.authenticated, username: username));
    } on DioException catch (e) {
      final msg = _parseError(e);
      state = AsyncData(AuthState(status: AuthStatus.unauthenticated, errorMessage: msg));
    }
  }

  Future<void> register(String username, String email, String password) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.register(username: username, email: email, password: password);
      state = AsyncData(AuthState(status: AuthStatus.authenticated, username: username));
    } on DioException catch (e) {
      final msg = _parseError(e);
      state = AsyncData(AuthState(status: AuthStatus.unauthenticated, errorMessage: msg));
    }
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(AuthState(status: AuthStatus.unauthenticated));
  }

  String _parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      final msg = data['message'];
      return msg is List ? msg.first.toString() : msg.toString();
    }
    return 'Xəta baş verdi. Yenidən cəhd edin.';
  }
}
