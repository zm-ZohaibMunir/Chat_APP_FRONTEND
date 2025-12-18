import 'dart:async';

import 'package:chat_app/features/home/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/update_heartbeat_usecase.dart';

class PresenceProvider extends ChangeNotifier with WidgetsBindingObserver {
  final UpdateHeartbeatUseCase _updateHeartbeatUseCase;
  final UsersProvider _usersProvider;

  Timer? _timer;

  PresenceProvider(this._updateHeartbeatUseCase, this._usersProvider);

  void startSystem() {
    WidgetsBinding.instance.addObserver(this);
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _callUpdate();
    _timer = Timer.periodic(Duration(minutes: 1), (t) => _callUpdate());
  }

  Future<void> _callUpdate() async {
    try {
      await _updateHeartbeatUseCase.execute();
      await _usersProvider.syncUsersStatus();
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runTimer();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  void stopSystem() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
