import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../home/presentation/providers/presence_provider.dart';

class ProfileProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService;

  ProfileProvider(this._secureStorageService);

  UserEntity? _user;
  UserEntity? get user => _user;

  void updateProfile(UserEntity newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _secureStorageService.deleteToken();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    Provider.of<PresenceProvider>(context, listen: false).stopSystem();
    _user = null;
    notifyListeners();
  }
}
