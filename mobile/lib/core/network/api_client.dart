import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_endpoints.dart';

class ApiClient {
  ApiClient._();

  static Dio create(SupabaseClient supabase) {
    final dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(_SupabaseAuthInterceptor(supabase));
    return dio;
  }
}

/// Hər HTTP sorğusuna cari Supabase JWT-ni `Authorization` başlığı kimi qoşur.
/// Token müddəti bitsə Supabase SDK avtomatik refresh edir — burada əlavə iş lazım deyil.
class _SupabaseAuthInterceptor extends QueuedInterceptorsWrapper {
  final SupabaseClient _supabase;

  _SupabaseAuthInterceptor(this._supabase);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _supabase.auth.currentSession?.accessToken;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        await _supabase.auth.refreshSession();
        final newToken = _supabase.auth.currentSession?.accessToken;
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final dio = Dio();
          final retry = await dio.fetch(err.requestOptions);
          return handler.resolve(retry);
        }
      } catch (_) {
        await _supabase.auth.signOut();
      }
    }
    handler.next(err);
  }
}
