
import 'package:chat_app/features/chats/domain/entities/status_entity.dart';

import '../repositories/chat_repository.dart';

class CheckStatusForAnyMsgUseCase {
  final ChatRepository repository;
  CheckStatusForAnyMsgUseCase(this.repository);

  Future<List<StatusEntity>> execute({
    required String partnerId,
    required String token,
  }) {
    return repository.checkStatusForAnyMsgRead(
      partnerId: partnerId,
      token: token,
    );
  }
}
