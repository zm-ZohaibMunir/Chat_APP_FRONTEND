import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_endpoints.dart';
import '../models/user_response_model.dart';
import '../models/user_status_response_model.dart';

class UsersRemoteDataSource {
  final http.Client client;

  UsersRemoteDataSource(this.client);

  Future<UserResponseModel> getUsers(int page, int limit, String token) async {
    try {
      final url = "${ApiConstants.fetchUsersEndPoint}?page=$page&limit=$limit";
      final response = await client
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));

      final Map<String, dynamic> decoded = json.decode(response.body);
      if (response.statusCode == 200) {
        return UserResponseModel.fromJson(decoded);
      } else {
        throw decoded['message'] ?? 'Session expired';
      }
    } on SocketException {
      throw 'No Internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserStatusResponseModel> getUsersStatus(
    List<String> ids,
    String token,
  ) async {
    // Join IDs into a comma-separated string: "id1,id2,id3"
    final idsParam = ids.join(',');

    final response = await client.get(
      Uri.parse("${ApiConstants.usersStatusEndPoint}?ids=$idsParam"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedBody = json.decode(response.body);
      final UserStatusResponseModel responseModel =
          UserStatusResponseModel.fromJson(decodedBody);
      return responseModel;
    } else {
      throw Exception("Failed to fetch statuses");
    }
  }
}
