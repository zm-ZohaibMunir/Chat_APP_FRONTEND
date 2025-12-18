import 'package:chat_app/features/home/domain/entities/single_user_entity.dart';

class UserResponseEntity {
  final List<SingleUserEntity> users;
  final bool hasNextPage;
  final int totalUsers;

  UserResponseEntity({
    required this.users,
    required this.hasNextPage,
    required this.totalUsers,
  });
}