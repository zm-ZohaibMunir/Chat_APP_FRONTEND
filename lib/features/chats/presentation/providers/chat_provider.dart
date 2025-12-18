import 'dart:async';

import 'package:chat_app/features/chats/domain/usecases/get_message_history_use_case.dart';
import 'package:chat_app/features/chats/domain/usecases/get_message_update_use_case.dart';
import 'package:chat_app/features/chats/domain/usecases/mark_as_read_use_case.dart';
import 'package:chat_app/features/chats/domain/usecases/send_message_use_case.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/check_status_for_any_msg_use_case.dart';

class ChatProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService;

  final SendMessageUseCase _sendMessageUseCase;
  final GetMessageHistoryUseCase _getMessageHistoryUseCase;
  final GetMessageUpdatesUseCase _getMessageUpdatesUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;
  final CheckStatusForAnyMsgUseCase _checkStatusForAnyMsgUseCase;

  ChatProvider(
    this._secureStorageService,
    this._sendMessageUseCase,
    this._getMessageHistoryUseCase,
    this._getMessageUpdatesUseCase,
    this._markAsReadUseCase,
    this._checkStatusForAnyMsgUseCase,
  );

  bool _isSending = false;
  bool get isSending => _isSending;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<MessageEntity> _messages = [];
  List<MessageEntity> get messages => _messages;

  // Pagination state for history
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoadingHistory = false;
  bool get isLoadingHistory => _isLoadingHistory;

  // CLEAR messages when entering a new chat
  void clearMessages() {
    _messages = [];
    _currentPage = 1;
    _hasNextPage = true;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String partnerId,
    required String text,
  })
  async {
    if (text.trim().isEmpty) return;

    _isSending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _secureStorageService.getToken();
      if (token == null) throw Exception("Session expired");

      final newMessage = await _sendMessageUseCase.execute(
        partnerId: partnerId,
        text: text,
        token: token,
      );

      _messages.insert(0, newMessage as MessageEntity);
      _isSending = false;
      notifyListeners();
    } catch (e) {
      _isSending = false;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchHistory({
    required String partnerId,
    bool isLoadMore = false,
  })
  async {
    if (_isLoadingHistory || (!isLoadMore && _messages.isNotEmpty)) return;
    if (isLoadMore && !_hasNextPage) return;

    _isLoadingHistory = true;
    notifyListeners();

    try {
      final token = await _secureStorageService.getToken();
      if (token == null) throw Exception("Session expired");

      final history = await _getMessageHistoryUseCase.execute(
        partnerId: partnerId,
        page: _currentPage,
        limit: 20,
        token: token,
      );

      if (isLoadMore) {
        // Append older messages to the end (top of the screen)
        _messages.addAll(history.messages.map((e)=> e as MessageEntity).toList());
      } else {
        // Initial load
        _messages = history.messages.map((e)=> e as MessageEntity).toList();
      }

      _hasNextPage = history.hasNextPage;
      if (_hasNextPage) _currentPage++;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingHistory = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead({required String partnerId}) async {
    try {
      final token = await _secureStorageService.getToken();
      if (token == null) return;

      await _markAsReadUseCase.execute(partnerId: partnerId, token: token);

      notifyListeners();
    } catch (e) {
      debugPrint("Mark as read error: $e");
      debugPrintStack();
    }
  }

  // Polling

  Timer? _pollingTimer;
  bool _isPolling = false;

  // 1. Start Polling
  void startPolling(String partnerId) {
    _stopTimer(); // Ensure no duplicate timers
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchUpdates(partnerId);
    });
  }

  // 2. Stop Polling (Crucial for battery/performance)
  void stopPolling() {
    _stopTimer();
  }

  void _stopTimer() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _fetchUpdates(String partnerId) async {
    if (_isPolling) return; // Prevent overlapping requests

    // Determine the "since" timestamp
    // If we have messages, take the createdAt of the newest one (index 0)
    // If empty, use current time
    DateTime since = _messages.isNotEmpty
        ? _messages.first.createdAt
        : DateTime.now().subtract(const Duration(seconds: 5));

    _isPolling = true;
    try {
      final token = await _secureStorageService.getToken();
      if (token == null) return;

      final newMessages = await _getMessageUpdatesUseCase.execute(
        partnerId: partnerId,
        since: since,
        token: token,
      );

      if (newMessages.isNotEmpty) {
        // Because backend sorts {createdAt: 1}, we got [OlderNew, NewerNew]
        // We need to insert them at index 0 in reverse to keep our list [Newest -> Oldest]
        for (var msg in newMessages) {
          // Avoid duplicates just in case
          if (!_messages.any((existing) => existing.id == msg.id)) {
            _messages.insert(0, msg as MessageEntity);
          }
        }
        notifyListeners();
      }
      // OPTIONAL: Also trigger markAsRead if we are actively looking at the screen
      // to ensure the partner sees their blue ticks immediately
      await markAsRead(partnerId: partnerId);

      // Check if any of MY sent messages have been read by the partner
      // We can re-fetch the status for the first few messages in the list
      await _syncReadStatus(partnerId);

      debugPrint("Polled");
    } catch (e) {
      debugPrint("Polling error: $e");
    } finally {
      _isPolling = false;
    }
  }

  // Check read status for sent Messages
  Future<void> _syncReadStatus(String partnerId) async {
    final token = await _secureStorageService.getToken();
    if (token == null) return;

    final statusUpdates = await _checkStatusForAnyMsgUseCase.execute(
      partnerId: partnerId,
      token: token,
    );
    bool changed = false;

    for (var update in statusUpdates) {
      // Find the message in our local list by ID
      int index = _messages.indexWhere((m) => m.id == update.id);

      if (index != -1) {
        // If the server says it's read but our UI says it's not
        if (update.isRead && !_messages[index].isRead) {
          _messages[index] = _messages[index].copyWith(isRead: true);
          changed = true;
        }
      }
    }
    if (changed) {
      notifyListeners(); // Refresh the UI to show Blue Ticks
    }

  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
