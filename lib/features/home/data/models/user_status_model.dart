import '../../domain/entities/user_status_entity.dart';

class UserStatusModel extends UserStatusEntity {
  UserStatusModel({
    required super.id,
    required super.lastSeen,
    required super.isAllowed,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      id: json['_id'],
      lastSeen: DateTime.parse(json['lastSeen']),
      isAllowed: json['isAllowed'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'lastSeen': lastSeen, 'isAllowed': isAllowed};
  }
}
