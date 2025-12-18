import '../../domain/entities/chat_history_entity.dart';
import 'message_model.dart';

class ChatHistoryModel extends ChatHistoryEntity {
  ChatHistoryModel({
    required super.messages,
    required super.hasNextPage,
    required super.totalMessages,
  });

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};
    return ChatHistoryModel(
      messages: (json['data'] as List? ?? [])
          .map((m) => MessageModel.fromJson(m))
          .toList(),
      hasNextPage: pagination['hasNextPage'] ?? false,
      totalMessages: pagination['totalMessages'] ?? 0,
    );
  }
}
