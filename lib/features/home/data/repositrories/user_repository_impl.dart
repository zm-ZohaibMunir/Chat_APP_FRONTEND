import 'package:chat_app/features/home/data/data_sources/users_remote_data_source.dart';
import 'package:chat_app/features/home/domain/entities/user_response_entity.dart';
import 'package:chat_app/features/home/domain/repositories/user_repository.dart';

import '../../domain/entities/user_status_response_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserResponseEntity> fetchUsers({
    int? page,
    int? limit,
    required String token,
  }) async {
    final UserResponseEntity usersResp = await remoteDataSource.getUsers(
      page ?? 1,
      limit ?? 10,
      token,
    );

    return usersResp;
  }

  @override
  Future<UserStatusResponseEntity> getUsersStatus(
    List<String> ids,
    String token,
  ) async {
    final UserStatusResponseEntity responseEntity = await remoteDataSource.getUsersStatus(
      ids,
      token,
    );

    return responseEntity;
  }
}
