import '../entities/chat_history_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessageHistoryUseCase {
  final ChatRepository repository;
  GetMessageHistoryUseCase(this.repository);

  Future<ChatHistoryEntity> execute({
    required String partnerId,
    required int page,
    required int limit,
    required String token,
  }) {
    return repository.getMessageHistory(
      partnerId: partnerId,
      page: page,
      limit: limit,
      token: token,
    );
  }
}
