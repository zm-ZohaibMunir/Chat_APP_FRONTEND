import '../../domain/repositories/presence_repository.dart';
import '../data_sources/presence_remote_data_source.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  final PresenceRemoteDataSource remoteDataSource;
  PresenceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> updateHeartbeat() async {
    return await remoteDataSource.sendHeartbeat();
  }
}
