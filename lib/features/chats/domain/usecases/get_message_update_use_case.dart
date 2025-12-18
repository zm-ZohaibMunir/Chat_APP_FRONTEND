import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessageUpdatesUseCase {
  final ChatRepository repository;
  GetMessageUpdatesUseCase(this.repository);

  Future<List<MessageEntity>> execute({
    required String partnerId,
    required DateTime since,
    required String token,
  }) {
    return repository.getMessageUpdates(
      partnerId: partnerId,
      since: since,
      token: token,
    );
  }
}
