import '../repositories/presence_repository.dart';

class UpdateHeartbeatUseCase {
  final PresenceRepository repository;
  UpdateHeartbeatUseCase(this.repository);

  Future<void> execute() async {
    return await repository.updateHeartbeat();
  }
}