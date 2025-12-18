import 'package:chat_app/features/auth/domain/entities/user_entity.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorageService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorageService,
  });

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await remoteDataSource.register(name, email, password);
    if (user.token != null) {
      await secureStorageService.saveToken(user.token!);
    }

    return user;
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final user = await remoteDataSource.login(email, password);
    if (user.token != null) {
      await secureStorageService.saveToken(user.token!);
    }

    return user;
  }

  @override
  Future<UserEntity> getMe(String token) async {
    return await remoteDataSource.getMe(token);
  }
}
