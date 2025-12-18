import '../entities/user_status_response_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersStatusUseCase {
  final UserRepository repository;
  GetUsersStatusUseCase(this.repository);

  Future<UserStatusResponseEntity> execute(List<String> ids, String token) async {
    return await repository.getUsersStatus(ids, token);
  }
}
