import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/constants/constants.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await client
          .post(
            Uri.parse(ApiConstants.registerEndPoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeoutDuration);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return UserModel.fromJson(data);
      } else {
        throw data['message'] ?? 'Registration failed';
      }
    } on SocketException {
      throw 'No Internet connection. Please check your network.';
    } on TimeoutException {
      throw 'The server is taking too long to respond. Try again later.';
    } on FormatException {
      throw 'Invalid response format from server.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client
          .post(
            Uri.parse(ApiConstants.loginEndPoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeoutDuration);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      } else {
        throw data['message'] ?? 'Login failed';
      }
    } on SocketException {
      throw 'No Internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again.';
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> getMe(String token) async {
    try {
      final response = await client
          .get(
            Uri.parse(ApiConstants.getMeEndPoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token', // Passing the secure token
            },
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return UserModel.fromJson(data);
      } else {
        throw data['message'] ?? 'Session expired';
      }
    } on SocketException {
      throw 'No Internet connection. Please check your network.';
    } on TimeoutException {
      throw 'Connection timed out. Please try again.';
    } catch (e) {
      throw e.toString();
    }
  }
}
