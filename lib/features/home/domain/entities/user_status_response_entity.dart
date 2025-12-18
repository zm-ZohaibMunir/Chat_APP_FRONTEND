import 'package:chat_app/features/home/domain/entities/user_status_entity.dart';

import 'new_activity_Entity.dart';

class UserStatusResponseEntity {
  final List<UserStatusEntity> statuses;
  final List<NewActivityEntity> newActivity;

  UserStatusResponseEntity({required this.statuses, required this.newActivity});
}