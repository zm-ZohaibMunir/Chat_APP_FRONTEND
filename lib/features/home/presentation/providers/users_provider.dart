import 'package:chat_app/features/home/domain/entities/single_user_entity.dart';
import 'package:chat_app/features/home/domain/usecases/get_users_use_case.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/utils.dart';
import '../../domain/usecases/get_users_status_use_case.dart';

class UsersProvider with ChangeNotifier {
  final GetUsersUseCase _getUsersUseCase;
  final SecureStorageService _secureStorageService;
  final GetUsersStatusUseCase _getUsersStatusUseCase;

  UsersProvider(
    this._getUsersUseCase,
    this._secureStorageService,
    this._getUsersStatusUseCase,
  );

  // State variables
  List<SingleUserEntity> _users = [];
  bool _isLoading = false; // Initial load / Pull-to-refresh
  bool _isFetchingMore = false; // Loading next page at bottom
  bool _hasNextPage = true; // Comes from our new API Meta
  int _currentPage = 1; // Keep track of current slice
  String? _errorMessage;

  // Getters
  List<SingleUserEntity> get users => _users;
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchUsers({bool isRefresh = false}) async {
    // 1. Prevent double-fetching or fetching if no more data exists
    if (_isFetchingMore || (_isLoading && !isRefresh)) return;
    if (!isRefresh && !_hasNextPage) return;

    _errorMessage = null;

    // 2. Setup state for Refresh vs. Pagination
    if (isRefresh) {
      _currentPage = 1;
      _hasNextPage = true;
      _setLoading(true); // Full screen loader
    } else {
      _isFetchingMore = true; // Bottom loader
      notifyListeners();
    }

    try {
      final token = await _secureStorageService.getToken();
      if (token == null) {
        _errorMessage = "Session expired. Please log in.";
        return;
      }

      // 3. Execute UseCase
      final response = await _getUsersUseCase.execute(
        page: _currentPage,
        limit: 15,
        token: token,
      );

      // 4. Update State
      if (isRefresh) {
        _users = response.users.map((e) => e as SingleUserEntity).toList();
      } else {
        _users.addAll(
          response.users.map((e) => e as SingleUserEntity).toList(),
        );
      }
      // if (isRefresh) {
      //   _users = response.users;
      // } else {
      //   _users.addAll(response.users);
      // }

      _hasNextPage = response.hasNextPage;
      if (_hasNextPage) _currentPage++;
    } catch (e) {
      _errorMessage = getReadableError(e);
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  Future<void> syncUsersStatus() async {
    if (_users.isEmpty) return;

    // 1. Get IDs of currently loaded users
    final List<String> ids = _users.map((u) => u.id).toList();

    try {
      final token = await _secureStorageService.getToken();
      if (token == null) {
        _errorMessage = "Session expired. Please log in.";
        return;
      }

      // 2. Fetch new statuses
      final response = await _getUsersStatusUseCase.execute(ids, token);

      // 3. Update existing entities in the list
      for (var status in response.statuses) {
        final index = _users.indexWhere((u) => u.id == status.id);
        if (index != -1) {
          _users[index] = _users[index].copyWith(
            lastSeen: status.lastSeen,
            isAllowed: status.isAllowed,
          );
        }
      }

      // 4. Handle New Messages (Activity)
      bool shouldRefreshList = false;
      for (var activity in response.newActivity) {
        final index = _users.indexWhere((u) => u.id == activity.senderId);

        if (index != -1) {
          // User is already in the list: Update their last message info
          _users[index] = _users[index].copyWith(
            lastMessageText: activity.lastMessageText,
            lastMessageTime: activity.lastMessageTime,
          );

          // OPTIONAL: Move them to the top of the list if a new message arrived
          final user = _users.removeAt(index);
          _users.insert(0, user);
        }
        else {
          // User NOT in the current list (maybe on page 2 or a new contact)
          shouldRefreshList = true;
        }
      }

      if (shouldRefreshList) {
        // If someone new messaged us,
        await fetchUsers(isRefresh: true);
      } else {
        notifyListeners();
      }

      debugPrint("Status Synced");
    } catch (e) {
      debugPrint("Status Sync Error: $e");
      debugPrintStack();
    }
  }
}
