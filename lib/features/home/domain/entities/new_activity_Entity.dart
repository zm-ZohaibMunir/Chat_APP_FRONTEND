class NewActivityEntity {
  final String senderId;
  final int unreadCount;
  final String lastMessageText;
  final DateTime lastMessageTime;

  NewActivityEntity({
    required this.senderId,
    required this.unreadCount,
    required this.lastMessageText,
    required this.lastMessageTime
  });
}