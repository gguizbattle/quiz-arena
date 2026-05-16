import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../constants/api_constants.dart';
import '../providers/app_providers.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/friends/providers/friend_provider.dart';
import '../../features/home/providers/user_provider.dart';

/// İstifadəçi auth-da olduqda backend `/realtime` namespace-inə qoşulur
/// və user-yönəlik push hadisələri qəbul edir (dostluq dəyişiklikləri, və s.).
/// Hadisə gələndə müvafiq Riverpod provider-i yenidən fetch edir.
class RealtimeService {
  final Ref _ref;
  io.Socket? _socket;
  String? _currentUserId;

  RealtimeService(this._ref);

  void connectFor(String userId) {
    if (_currentUserId == userId && _socket?.connected == true) return;
    disconnect();
    _currentUserId = userId;
    debugPrint('[rt] connecting for user=${userId.substring(0, 8)}');
    _socket = io.io(
      '${ApiConstants.wsUrl}/realtime',
      io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _socket!.onConnect((_) {
      debugPrint('[rt] connected, sock=${_socket!.id}');
      _socket!.emit('presence:join', {'userId': userId});
    });
    _socket!.on('presence:joined', (_) => debugPrint('[rt] joined user room'));
    _socket!.on('friends:changed', (data) {
      debugPrint('[rt] ← friends:changed $data');
      // FriendsProvider-i refresh et (currentVa state-ə abone widget-lər dərhal yenilənir)
      // Async safe — notifier hələ build olmamışsa hər şey OK keçər.
      try {
        _ref.read(friendsProvider.notifier).refresh();
      } catch (e) {
        debugPrint('[rt] friends refresh failed: $e');
      }
    });
    _socket!.onDisconnect((_) => debugPrint('[rt] disconnected'));
    _socket!.onConnectError((e) => debugPrint('[rt] connect error: $e'));
    _socket!.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _currentUserId = null;
  }
}

/// Provider — auth dəyişəndə avtomatik connect/disconnect edir.
final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final service = RealtimeService(ref);
  ref.onDispose(service.disconnect);
  // Auth state-i izlə
  ref.listen<AsyncValue<AuthState>>(authProvider, (prev, next) {
    next.whenData((s) {
      if (s.status == AuthStatus.authenticated) {
        // user.id-ni profile-dan al
        final profile = ref.read(userProfileProvider).valueOrNull;
        if (profile != null) {
          service.connectFor(profile.id);
        }
      } else {
        service.disconnect();
      }
    });
  });
  // Profil yüklənəndə də cəhd et (auth artıq authenticated-dirsə)
  ref.listen<AsyncValue>(userProfileProvider, (prev, next) {
    next.whenData((p) {
      if (p?.id != null) service.connectFor(p.id as String);
    });
  });
  return service;
});
