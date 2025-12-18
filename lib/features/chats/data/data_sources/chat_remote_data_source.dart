import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';
import '../models/chat_history_model.dart';
import '../models/message_model.dart';
import '../models/status_model.dart';

class ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSource(this.client);

  Future<MessageModel> sendMessage({
    required String partnerId,
    required String text,
    required String token,
  })
  async {
    try {
      final response = await client
          .post(
            Uri.parse(ApiConstants.messagesEndPoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'receiverId': partnerId, 'text': text}),
          )
          .timeout(const Duration(seconds: 10));

      final decoded = json.decode(response.body);
      if (response.statusCode == 201) {
        return MessageModel.fromJson(decoded['data']);
      } else {
        throw decoded['message'] ?? 'Failed to send message';
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ChatHistoryModel> getMessageHistory({
    required String partnerId,
    required int page,
    required int limit,
    required String token,
  })
  async {
    try {
      final url =
          "${ApiConstants.messagesEndPoint}/$partnerId/history?page=$page&limit=$limit";
      final response = await client.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        return ChatHistoryModel.fromJson(decoded);
      } else {
        throw decoded['message'] ?? 'Failed to load history';
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 3. Get Message Updates (Polling)
  Future<List<MessageModel>> getMessageUpdates({
    required String partnerId,
    required DateTime since,
    required String token,
  })
  async {
    try {
      // Use toIso8601String to match Mongoose/JavaScript Date format
      final url =
          "${ApiConstants.messagesEndPoint}/$partnerId/updates?since=${since.toIso8601String()}";

      final response = await client.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data.map((m) => MessageModel.fromJson(m)).toList();
      } else {
        throw 'Polling failed';
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markMessagesAsRead({
    required String partnerId,
    required String token,
  })
  async {
    final url = "${ApiConstants.messagesEndPoint}/$partnerId/read";
    final response = await client.patch(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw 'Failed to mark messages as read';
    }
  }


  Future<List<StatusModel>> syncMessageReadStatus({
    required String partnerId,
    required String token,
  })
  async {
    try {
      final url = "${ApiConstants.messagesEndPoint}/$partnerId/sync";
      final response = await client.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      final decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        return data.map((m) => StatusModel.fromJson(m)).toList();
      } else {
        throw decoded['message'] ?? 'Failed to Check Status';
      }
    } catch (e){
      throw _handleError(e);
    }
  }

  String _handleError(dynamic e) {
    if (e is SocketException) return "Check your internet connection.";
    if (e is TimeoutException) return "Server timed out.";
    return e.toString();
  }
}
