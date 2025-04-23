import 'package:flutter/material.dart';
import '/data/models/user_model.dart';
import '/data/repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repo;

  String email = '';
  String password = '';
  bool isLoading = false;

  static const int _maxEmailLen = 50;
  static const int _maxPassLen = 20;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}\$');

  LoginViewModel({AuthRepository? repository})
      : _repo = repository ?? AuthRepository();

  void setEmail(String value) {
    email = value.trim();
  }

  void setPassword(String value) {
    password = value.trim();
  }

  Future<void> login(BuildContext context) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      _showMessage(context, 'Please enter your email and password.');
      return;
    }
    if (email.length > _maxEmailLen) {
      _showMessage(context, 'Email must be at most $_maxEmailLen characters.');
      return;
    }
    if (!_emailRegex.hasMatch(email)) {
      _showMessage(context, 'Please enter a valid email address.');
      return;
    }
    if (password.length > _maxPassLen) {
      _showMessage(
          context, 'Password must be at most $_maxPassLen characters.');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final User? user = await _repo.signIn(email, password);
      if (user != null) {
        _showMessage(context, 'Login successful! Welcome ${user.email}.');
        Navigator.pushNamed(context, '/home');
      } else {
        _showMessage(context, 'Login failed. Please check your credentials.');
      }
    } catch (e) {
      _showMessage(context, 'An error occurred: \$e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(BuildContext ctx, String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
