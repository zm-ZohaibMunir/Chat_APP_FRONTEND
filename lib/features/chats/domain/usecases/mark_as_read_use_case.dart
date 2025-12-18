import '../repositories/chat_repository.dart';

class MarkAsReadUseCase {
  final ChatRepository repository;
  MarkAsReadUseCase(this.repository);

  Future<void> execute({required String partnerId, required String token}) {
    return repository.markMessagesAsRead(partnerId: partnerId, token: token);
  }
}