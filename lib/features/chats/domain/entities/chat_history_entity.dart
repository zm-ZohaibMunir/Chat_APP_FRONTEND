import 'message_entity.dart';

class ChatHistoryEntity {
  final List<MessageEntity> messages;
  final bool hasNextPage;
  final int totalMessages;

  ChatHistoryEntity({
    required this.messages,
    required this.hasNextPage,
    required this.totalMessages,
  });
}