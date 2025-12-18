import 'package:chat_app/features/chats/domain/entities/status_entity.dart';

import '../../domain/entities/chat_history_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../data_sources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MessageEntity> sendMessage({
    required String partnerId,
    required String text,
    required String token,
  }) async {
    return await remoteDataSource.sendMessage(
      partnerId: partnerId,
      text: text,
      token: token,
    );
  }

  @override
  Future<ChatHistoryEntity> getMessageHistory({
    required String partnerId,
    required int page,
    required int limit,
    required String token,
  }) async {
    return await remoteDataSource.getMessageHistory(
      partnerId: partnerId,
      page: page,
      limit: limit,
      token: token,
    );
  }

  @override
  Future<List<MessageEntity>> getMessageUpdates({
    required String partnerId,
    required DateTime since,
    required String token,
  }) async {
    return await remoteDataSource.getMessageUpdates(
      partnerId: partnerId,
      since: since,
      token: token,
    );
  }

  @override
  Future<void> markMessagesAsRead({
    required String partnerId,
    required String token,
  }) async {
    await remoteDataSource.markMessagesAsRead(
      partnerId: partnerId,
      token: token,
    );
  }

  @override
  Future<List<StatusEntity>> checkStatusForAnyMsgRead({
    required String partnerId,
    required String token,
  }) async {
    return await remoteDataSource.syncMessageReadStatus(
      partnerId: partnerId,
      token: token,
    );
  }
}
