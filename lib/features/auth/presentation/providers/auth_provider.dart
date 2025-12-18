import 'package:chat_app/features/auth/domain/usecases/get_me_use_case.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/secure_storage_service.dart';
import '../../../settings/presentation/providers/profile_provider.dart';

class AuthProvider with ChangeNotifier {
  final GetMeUseCase _getMeUseCase;
  final SecureStorageService _secureStorageService;
  final ProfileProvider _profileProvider;
  AuthProvider(
    this._getMeUseCase,
    this._secureStorageService,
    this._profileProvider,
  );

  Future<bool> checkAuthStatus() async {
    final token = await _secureStorageService.getToken();
    if (token == null) return false;

    try {
      final user = await _getMeUseCase.execute(token);
      _profileProvider.updateProfile(user);
      return true;
    } catch (e) {
      await _secureStorageService.deleteToken();
      return false;
    }
  }
}
