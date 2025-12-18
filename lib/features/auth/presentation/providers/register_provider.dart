import 'package:chat_app/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils.dart';
import '../../../settings/presentation/providers/profile_provider.dart';

class RegisterProvider with ChangeNotifier {
  final RegisterUseCase _registerUseCase;

  RegisterProvider(this._registerUseCase);


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPasswordObSecure = true;
  bool get isPasswordObSecure => _isPasswordObSecure;

  bool _isConfirmPasswordObSecure = true;
  bool get isConfirmPasswordObSecure => _isConfirmPasswordObSecure;

  void togglePasswordObSecure() {
    _isPasswordObSecure = !_isPasswordObSecure;
    notifyListeners();
  }

  void toggleConfirmPasswordObSecure() {
    _isConfirmPasswordObSecure = !_isConfirmPasswordObSecure;
    notifyListeners();
  }

  // The Core Register Functionality
  Future<void> login({
    required BuildContext context,
    required ProfileProvider profileProvider,
  }) async {
    // Basic Validation
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showError(context, "Please fill in all fields");
      return;
    }

    _setLoading(true);

    try {
      // 1. Call the Repository
      final user = await _registerUseCase.execute(
        name: nameController.text.trim(),
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
    _isConfirmPasswordObSecure = true;
    _isLoading = false;
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
