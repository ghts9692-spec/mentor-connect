import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

export '../services/chat_service.dart' show chatServiceProvider;

final conversationsProvider =
    FutureProvider.autoDispose<List<Conversation>>((ref) {
  return ref.read(chatServiceProvider).getConversations();
});

final messagesProvider =
    FutureProvider.autoDispose.family<List<Message>, String>(
  (ref, conversationId) =>
      ref.read(chatServiceProvider).getMessages(conversationId),
);
