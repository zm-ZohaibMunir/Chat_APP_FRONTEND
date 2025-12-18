import 'package:chat_app/features/home/domain/entities/single_user_entity.dart';

class SingleUserModel extends SingleUserEntity {
  SingleUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.isAllowed,
    required super.lastSeen,
    super.lastMessageText,
    super.lastMessageTime,
  });

  factory SingleUserModel.fromJson(Map<String, dynamic> json) {
    return SingleUserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      isAllowed: json['isAllowed'] ?? true,
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : DateTime.now(),
      lastMessageText: json['lastMessageText'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'isAllowed': isAllowed,
      'lastSeen': lastSeen.toIso8601String(),
    };
  }
}
