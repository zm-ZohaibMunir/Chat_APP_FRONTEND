import '../../domain/entities/user_response_entity.dart';
import 'single_user_model.dart';

class UserResponseModel extends UserResponseEntity {
  UserResponseModel({
    required super.users,
    required super.hasNextPage,
    required super.totalUsers,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      users: (json['data'] as List)
          .map((i) => SingleUserModel.fromJson(i))
          .toList(),
      hasNextPage: json['pagination']['hasNextPage'] ?? false,
      totalUsers: json['pagination']['totalUsers'] ?? 0,
    );
  }
}