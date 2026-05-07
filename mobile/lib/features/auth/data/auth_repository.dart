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
    final response = await _dio.post(ApiEndpoints.register, data: {
      'username': username,
      'email': email,
      'password': password,
    });
    await _saveTokens(response.data);
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    final response = await _dio.post(ApiEndpoints.login, data: {
      'identifier': identifier,
      'password': password,
    });
    await _saveTokens(response.data);
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } finally {
      await _storage.deleteAll();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'access_token');
    return token != null;
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
