import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/services/secure_storage_service.dart';

class PresenceRemoteDataSource {
  final http.Client client;
  final SecureStorageService secureStorageService;

  PresenceRemoteDataSource(this.client, this.secureStorageService);

  Future<void> sendHeartbeat() async {
    final token = await secureStorageService.getToken();

    try {
      final response = await client.patch(
        Uri.parse(ApiConstants.hearBeatEndPoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint("Heartbeat: Success (Last seen updated)");
      } else {
        debugPrint("Heartbeat: Failed with status ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Heartbeat: Network error or Exception: $e");
      rethrow;
    }
  }
}
