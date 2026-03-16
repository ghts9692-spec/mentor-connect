import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import 'api_service.dart';
import 'token_service.dart';

final chatServiceProvider = Provider(
  (ref) => ChatService(ref.read(apiServiceProvider)),
);

class ChatService {
  final ApiService _api;
  final _tokenService = TokenService();

  ChatService(this._api);

  /// List all conversations for the authenticated user.
  Future<List<Conversation>> getConversations() async {
    final data = await _api.get('/chats/');
    final list = data as List<dynamic>;
    return list
        .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get the message history for a conversation.
  Future<List<Message>> getMessages(String conversationId) async {
    final data = await _api.get('/chats/$conversationId/messages/');
    final list = data as List<dynamic>;
    return list
        .map((e) => Message.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Send a text message in a conversation.
  Future<Message> sendMessage(String conversationId, String text) async {
    final data = await _api.post(
      '/chats/$conversationId/messages/',
      {'text': text},
    );
    return Message.fromJson(data as Map<String, dynamic>);
  }

  /// Opens a WebSocket connection for real-time messages.
  /// Returns a [WebSocketChannel] – listen to `.stream` for incoming messages.
  Future<WebSocketChannel> connectWebSocket(String conversationId) async {
    final token = await _tokenService.readAccessToken();
    final uri = Uri.parse(
      'ws://10.0.2.2:8000/ws/chat/$conversationId/?token=$token',
    );
    return WebSocketChannel.connect(uri);
  }
}
