import 'package:chat_app/features/chats/domain/entities/status_entity.dart';

import '../entities/chat_history_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // POST /api/messages/:partnerId
  Future<MessageEntity> sendMessage({
    required String partnerId,
    required String text,
    required String token,
  });

  // GET /api/messages/:partnerId/history
  Future<ChatHistoryEntity> getMessageHistory({
    required String partnerId,
    required int page,
    required int limit,
    required String token,
  });

  // GET /api/messages/:partnerId/updates?since=...
  Future<List<MessageEntity>> getMessageUpdates({
    required String partnerId,
    required DateTime since,
    required String token,
  });

  // Patch /api/messages/:partnerId/read

  Future<void> markMessagesAsRead({
    required String partnerId,
    required String token,
  });

  // GET /api/messages/:partnerId/sync
  Future<List<StatusEntity>> checkStatusForAnyMsgRead({
    required String partnerId,
    required String token,
  });
}
