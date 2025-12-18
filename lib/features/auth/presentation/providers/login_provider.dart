import 'package:flutter/material.dart';
import '../../../../core/utils/utils.dart';
import '../../../settings/presentation/providers/profile_provider.dart';
import '../../domain/usecases/login_use_case.dart';

class LoginProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginProvider(this._loginUseCase);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordObSecure = true;
  bool get isPasswordObSecure => _isPasswordObSecure;

  void togglePasswordObSecure() {
    _isPasswordObSecure = !_isPasswordObSecure;
    notifyListeners();
  }

  // The Core Login Functionality
  Future<void> login({
    required BuildContext context,
    required ProfileProvider profileProvider,
  })
  async {
    // Basic Validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showError(context, "Please fill in all fields");
      return;
    }

    _setLoading(true);

    try {
      // 1. Call the Repository
      final user = await _loginUseCase.execute(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // 2. Hand-off data to the ProfileProvider
      profileProvider.updateProfile(user);

      // 3. Clear fields and navigate
      clearFields();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      debugPrint(e.toString());
      debugPrintStack();
      // Catch the custom errors from our Data Source (Timeout, No Internet, etc.)
      if (context.mounted) {
        showError(context, e.toString());
      }
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearFields() {
    _isPasswordObSecure = true;
    _isLoading = false;
    emailController.clear();
    passwordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
