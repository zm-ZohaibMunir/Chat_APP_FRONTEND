import 'package:chat_app/features/home/data/models/user_status_model.dart';
import 'package:chat_app/features/home/domain/entities/user_status_response_entity.dart';

import 'new_activity_model.dart';

class UserStatusResponseModel extends UserStatusResponseEntity {
  UserStatusResponseModel({
    required super.statuses,
    required super.newActivity,
  });

  factory UserStatusResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return UserStatusResponseModel(
      statuses: (data['statuses'] as List? ?? [])
          .map((item) => UserStatusModel.fromJson(item))
          .toList(),
      newActivity: (data['newActivity'] as List? ?? [])
          .map((item) => NewActivityModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'statuses': statuses
            .map((e) => (e as UserStatusModel).toJson())
            .toList(),
        'newActivity': newActivity
            .map((e) => (e as NewActivityModel).toJson())
            .toList(),
      },
    };
  }
}
