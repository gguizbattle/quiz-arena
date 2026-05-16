import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/constants/api_constants.dart';

class ChatMessage {
  final String id;
  final String fromUserId;
  final String text;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.fromUserId,
    required this.text,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
        id: j['id'] as String,
        fromUserId: j['fromUserId'] as String,
        text: j['text'] as String,
        sentAt: DateTime.fromMillisecondsSinceEpoch((j['sentAt'] as num).toInt()),
      );
}

/// Ephemeral 1:1 chat — bütün mesajlar yalnız aktiv session-da yaşayır.
/// Yazışmadan çıxanda `close()` çağırılmalıdır ki, server-də də silinsin.
class ChatSocketService {
  io.Socket? _socket;
  String? _chatId;

  bool get isConnected => _socket?.connected ?? false;
  String? get chatId => _chatId;

  void connect({void Function()? onConnected, void Function(Object)? onError}) {
    if (_socket != null && _socket!.connected) {
      onConnected?.call();
      return;
    }
    debugPrint('[chat-ws] connecting');
    _socket ??= io.io(
      '${ApiConstants.wsUrl}/chat',
      io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    _socket!.onConnect((_) {
      debugPrint('[chat-ws] connected, sock=${_socket!.id}');
      onConnected?.call();
    });
    _socket!.onDisconnect((_) => debugPrint('[chat-ws] disconnected'));
    _socket!.onConnectError((e) {
      debugPrint('[chat-ws] connect error: $e');
      onError?.call(e as Object);
    });
    _socket!.connect();
  }

  void open({
    required String userId,
    required String peerId,
    required void Function(String chatId, List<ChatMessage> initialMessages, bool peerOnline) onOpened,
    required void Function(ChatMessage) onMessage,
    required void Function() onPeerJoined,
    required void Function() onPeerLeft,
    required void Function(bool isTyping) onTyping,
    required void Function(String code) onError,
  }) {
    _socket!.on('chat:opened', (data) {
      if (data is Map) {
        final cid = data['chatId'] as String;
        _chatId = cid;
        final msgs = (data['messages'] as List?)
                ?.map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m as Map)))
                .toList() ??
            [];
        onOpened(cid, msgs, data['peerOnline'] == true);
      }
    });
    _socket!.on('chat:message', (data) {
      if (data is Map) onMessage(ChatMessage.fromJson(Map<String, dynamic>.from(data)));
    });
    _socket!.on('chat:peer-joined', (_) => onPeerJoined());
    _socket!.on('chat:peer-left', (_) => onPeerLeft());
    _socket!.on('chat:typing', (data) {
      if (data is Map) onTyping(data['isTyping'] == true);
    });
    _socket!.on('chat:error', (data) {
      if (data is Map) onError(data['code'] as String? ?? 'unknown');
    });
    _socket!.emit('chat:open', {'userId': userId, 'peerId': peerId});
  }

  void send(String text) {
    if (_chatId == null) return;
    _socket?.emit('chat:send', {'chatId': _chatId, 'text': text});
  }

  void setTyping(bool isTyping) {
    if (_chatId == null) return;
    _socket?.emit('chat:typing', {'chatId': _chatId, 'isTyping': isTyping});
  }

  void close() {
    if (_chatId != null) {
      _socket?.emit('chat:close', {'chatId': _chatId});
      _chatId = null;
    }
    _socket?.off('chat:opened');
    _socket?.off('chat:message');
    _socket?.off('chat:peer-joined');
    _socket?.off('chat:peer-left');
    _socket?.off('chat:typing');
    _socket?.off('chat:error');
  }

  void disconnect() {
    close();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
