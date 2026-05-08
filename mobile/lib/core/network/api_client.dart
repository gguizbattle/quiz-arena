import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  ApiClient._();

  static Dio create(FlutterSecureStorage storage) {
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(_AuthInterceptor(dio, storage));
    return dio;
  }
}

class _AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._dio, this._storage);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(key: 'refresh_token');
        if (refreshToken == null) return handler.next(err);

        final userId = await _storage.read(key: 'user_id');
        final response = await _dio.post(
          ApiEndpoints.refresh,
          data: {'user_id': userId, 'refresh_token': refreshToken},
          options: Options(headers: {'Authorization': null}),
        );

        final newAccess = response.data['access_token'] as String;
        final newRefresh = response.data['refresh_token'] as String;
        await _storage.write(key: 'access_token', value: newAccess);
        await _storage.write(key: 'refresh_token', value: newRefresh);

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
        final retry = await _dio.fetch(err.requestOptions);
        return handler.resolve(retry);
      } catch (_) {
        await _storage.deleteAll();
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
