import 'package:chat_app/features/home/domain/entities/new_activity_Entity.dart';

class NewActivityModel extends NewActivityEntity {
  NewActivityModel({
    required super.senderId,
    required super.unreadCount,
    required super.lastMessageText,
    required super.lastMessageTime,
  });

  factory NewActivityModel.fromJson(Map<String, dynamic> json) {
    return NewActivityModel(
      senderId: json['_id'],
      unreadCount: json['unreadCount'],
      lastMessageText: json['lastMessageText'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': senderId,
      'unreadCount': unreadCount,
      'lastMessageText': lastMessageText,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }
}
