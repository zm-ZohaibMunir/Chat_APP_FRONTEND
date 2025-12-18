class UserStatusEntity {
  final String id;
  final DateTime lastSeen;
  final bool isAllowed;

  UserStatusEntity({required this.id, required this.lastSeen, required this.isAllowed});
}