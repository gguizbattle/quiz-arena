import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/network/api_endpoints.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  const AuthRepository(this._dio, this._storage);

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.register, data: {
        'username': username,
        'email': email,
        'password': password,
      });
      await _saveTokens(response.data);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        await _saveOfflineSession(username: username, email: email);
        return;
      }
      rethrow;
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.login, data: {
        'identifier': identifier,
        'password': password,
      });
      await _saveTokens(response.data);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        final username = identifier.contains('@')
            ? identifier.split('@').first
            : identifier;
        await _saveOfflineSession(
          username: username,
          email: identifier.contains('@') ? identifier : null,
        );
        return;
      }
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {
      // backend yoxdursa belə, lokal sessiyanı təmizlə
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
  }

  bool _isNetworkError(DioException e) {
    return e.response == null ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.unknown;
  }

  Future<void> _saveOfflineSession({
    required String username,
    String? email,
  }) async {
    await _storage.write(key: 'access_token', value: 'offline_token');
    await _storage.write(key: 'refresh_token', value: 'offline_refresh');
    await _storage.write(key: 'user_id', value: 'offline_user');
    await _storage.write(key: 'username', value: username);
    if (email != null) {
      await _storage.write(key: 'email', value: email);
    }
    await _storage.write(key: 'offline_mode', value: 'true');
  }

  Future<void> _saveTokens(Map<String, dynamic> data) async {
    await _storage.write(key: 'access_token', value: data['access_token'] as String);
    await _storage.write(key: 'refresh_token', value: data['refresh_token'] as String);
    if (data['user'] != null) {
      final user = data['user'] as Map<String, dynamic>;
      await _storage.write(key: 'user_id', value: user['id']?.toString());
      await _storage.write(key: 'username', value: user['username']?.toString());
    }
  }
}
