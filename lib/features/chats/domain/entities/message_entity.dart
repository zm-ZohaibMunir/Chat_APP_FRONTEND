class MessageEntity {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final bool isRead;
  final DateTime createdAt;

  MessageEntity({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.isRead,
    required this.createdAt,
  });

  MessageEntity copyWith({
    String? id,
    String? sender,
    String? receiver,
    String? text,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      text: text ?? this.text,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Helper to determine if I sent this message
  bool isMe(String currentUserId) => sender == currentUserId;
}
