import 'package:dio/dio.dart';

class FriendSummary {
  final String friendshipId;
  final String userId;
  final String username;
  final String friendCode;
  final String? avatar;
  final int level;
  final int elo;

  const FriendSummary({
    required this.friendshipId,
    required this.userId,
    required this.username,
    required this.friendCode,
    this.avatar,
    required this.level,
    required this.elo,
  });

  factory FriendSummary.fromJson(Map<String, dynamic> j) => FriendSummary(
        friendshipId: j['friendshipId'] as String? ?? '',
        userId: j['id'] as String,
        username: j['username'] as String,
        friendCode: j['friend_code'] as String? ?? '',
        avatar: j['avatar'] as String?,
        level: (j['level'] as num?)?.toInt() ?? 1,
        elo: (j['elo'] as num?)?.toInt() ?? 1000,
      );
}

class PendingRequests {
  final List<FriendSummary> incoming;
  final List<FriendSummary> outgoing;
  const PendingRequests({required this.incoming, required this.outgoing});
}

class FriendRepository {
  final Dio _dio;
  const FriendRepository(this._dio);

  Future<FriendSummary> lookupByCode(String code) async {
    final r = await _dio.get('/friends/lookup', queryParameters: {'code': code});
    return FriendSummary.fromJson(r.data as Map<String, dynamic>);
  }

  Future<List<FriendSummary>> listFriends() async {
    final r = await _dio.get('/friends');
    return (r.data as List).map((e) => FriendSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PendingRequests> listPending() async {
    final r = await _dio.get('/friends/pending');
    final data = r.data as Map<String, dynamic>;
    return PendingRequests(
      incoming: (data['incoming'] as List).map((e) => FriendSummary.fromJson(e as Map<String, dynamic>)).toList(),
      outgoing: (data['outgoing'] as List).map((e) => FriendSummary.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Future<List<FriendSummary>> listBlocked() async {
    final r = await _dio.get('/friends/blocked');
    return (r.data as List).map((e) => FriendSummary.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> sendRequest(String code) async {
    await _dio.post('/friends/request', data: {'code': code});
  }

  Future<void> accept(String friendshipId) async {
    await _dio.post('/friends/$friendshipId/accept');
  }

  Future<void> removeOrDecline(String friendshipId) async {
    await _dio.delete('/friends/$friendshipId');
  }

  Future<void> block(String code) async {
    await _dio.post('/friends/block', data: {'code': code});
  }

  Future<void> unblock(String friendshipId) async {
    await _dio.post('/friends/$friendshipId/unblock');
  }
}
