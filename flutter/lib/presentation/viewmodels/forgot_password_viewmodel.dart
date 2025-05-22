import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';
import '/data/models/recover_response.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  String email = '';
  bool isLoading = false;

  // Validation constants
  static const int _maxEmailLen = 50;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$');

  ForgotPasswordViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  void setEmail(String value) => email = value.trim();

  Future<void> recover(BuildContext context) async {
    // 1) Required
    if (email.isEmpty) {
      _showMessage(context, 'Please enter your email.');
      return;
    }
    // 2) Max length
    if (email.length > _maxEmailLen) {
      _showMessage(context, 'Email must be at most $_maxEmailLen characters.');
      return;
    }
    // 3) Format
    if (!_emailRegex.hasMatch(email)) {
      _showMessage(context, 'Please enter a valid email address.');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final RecoverResponse resp = await _repository.recoverPassword(email);
      _showMessage(context, resp.message);
    } catch (e) {
      _showMessage(context,
          'An error occurred sending recovery email. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
