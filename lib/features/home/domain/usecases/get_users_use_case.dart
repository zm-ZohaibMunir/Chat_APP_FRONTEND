import '../entities/user_response_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<UserResponseEntity> execute({
    int page = 1,
    int limit = 10,
    required String token,
  }) async {
    return await repository.fetchUsers(page: page, limit: limit, token: token);
  }
}
