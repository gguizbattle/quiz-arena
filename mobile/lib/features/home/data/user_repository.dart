import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProfile {
  final String id;
  final String username;
  final String? email;
  final String? avatar;
  final int xp;
  final int level;
  final int coins;
  final int elo;
  final int wins;
  final int losses;
  final bool isPremium;

  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.avatar,
    required this.xp,
    required this.level,
    required this.coins,
    required this.elo,
    required this.wins,
    required this.losses,
    required this.isPremium,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
        id: j['id'] as String,
        username: j['username'] as String,
        email: j['email'] as String?,
        avatar: j['avatar'] as String?,
        xp: (j['xp'] as num).toInt(),
        level: (j['level'] as num).toInt(),
        coins: (j['coins'] as num).toInt(),
        elo: (j['elo'] as num).toInt(),
        wins: (j['wins'] as num).toInt(),
        losses: (j['losses'] as num).toInt(),
        isPremium: j['is_premium'] as bool? ?? false,
      );

  factory UserProfile.offline({required String username, String? email}) =>
      UserProfile(
        id: 'offline_user',
        username: username,
        email: email,
        avatar: null,
        xp: 0,
        level: 1,
        coins: 0,
        elo: 1000,
        wins: 0,
        losses: 0,
        isPremium: false,
      );

  int get totalGames => wins + losses;
  double get winRate => totalGames == 0 ? 0 : wins / totalGames;

  int get xpForCurrentLevel => (level - 1) * 1000;
  int get xpForNextLevel => level * 1000;
  double get levelProgress {
    final current = xp - xpForCurrentLevel;
    final needed = xpForNextLevel - xpForCurrentLevel;
    return needed == 0 ? 0 : (current / needed).clamp(0.0, 1.0);
  }
}

class UserRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  const UserRepository(this._dio, this._storage);

  Future<UserProfile> getMe() async {
    try {
      final response = await _dio.get('/users/me');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (_isNetworkError(e)) {
        final username = await _storage.read(key: 'username') ?? 'Player';
        final email = await _storage.read(key: 'email');
        return UserProfile.offline(username: username, email: email);
      }
      rethrow;
    }
  }

  bool _isNetworkError(DioException e) {
    return e.response == null ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.unknown;
  }
}
