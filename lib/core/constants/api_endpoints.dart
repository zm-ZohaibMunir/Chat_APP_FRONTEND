class ApiConstants {
  static String get baseUrl => "ipAddress/api";

  static String get registerEndPoint => "$baseUrl/auth/register";
  static String get loginEndPoint => "$baseUrl/auth/login";
  static String get getMeEndPoint => "$baseUrl/auth/me";

  static String get fetchUsersEndPoint => "$baseUrl/users";
  static String get hearBeatEndPoint => "$baseUrl/users/hearbeat";
  static String get usersStatusEndPoint => "$baseUrl/users/status";
  static String get messagesEndPoint => "$baseUrl/messages";
}
