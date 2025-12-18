class SingleUserEntity {
  final String id;
  final String name;
  final String email;
  final bool isAllowed;
  final DateTime lastSeen;
  final String? lastMessageText;
  final DateTime? lastMessageTime;
  SingleUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.isAllowed,
    required this.lastSeen,
    this.lastMessageText,
    this.lastMessageTime,
  });
  SingleUserEntity copyWith({
    bool? isAllowed,
    DateTime? lastSeen,
    String? lastMessageText,
    DateTime? lastMessageTime,
  }) {
    return SingleUserEntity(
      id: id,
      name: name,
      email: email,
      isAllowed: isAllowed ?? this.isAllowed,
      lastSeen: lastSeen ?? this.lastSeen,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
    );
  }
}
