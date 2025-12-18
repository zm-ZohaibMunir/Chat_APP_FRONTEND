import '../entities/user_response_entity.dart';
import '../entities/user_status_response_entity.dart';

abstract class UserRepository {
  Future<UserResponseEntity> fetchUsers({
    int? page,
    int? limit,
    required String token,
  });

  // This to get the online status of given users plus check any message from any user
  Future<UserStatusResponseEntity> getUsersStatus(List<String> ids, String token);
}
