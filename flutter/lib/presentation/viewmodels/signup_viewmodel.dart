import 'package:flutter/material.dart';
import '/data/repositories/auth_repository.dart';
import '/data/models/signup_response.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  String fullName = '';
  String email = '';
  String phone = '';
  String dob = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  // Límites de longitud
  static const int _maxNameLen = 50;
  static const int _maxEmailLen = 50;
  static const int _maxPhoneLen = 10;
  static const int _maxPassLen = 20;

  // Regex para formatos
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$');
  final RegExp _phoneRegex = RegExp(r'^\d+$');

  SignupViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  void setFullName(String v) => fullName = v.trim();
  void setEmail(String v) => email = v.trim();
  void setPhone(String v) => phone = v.trim();
  void setDob(String v) => dob = v.trim();
  void setPassword(String v) => password = v.trim();
  void setConfirmPassword(String v) => confirmPassword = v.trim();

  Future<void> signup(BuildContext context) async {
    // 1. Campos obligatorios
    if ([fullName, email, phone, dob, password, confirmPassword]
        .any((s) => s.isEmpty)) {
      _showMessage(context, 'All fields are mandatory.');
      return;
    }
    // 2. Longitudes máximas
    if (fullName.length > _maxNameLen) {
      _showMessage(
          context, 'Full name must be at most $_maxNameLen characters.');
      return;
    }
    if (email.length > _maxEmailLen) {
      _showMessage(context, 'Email must be at most $_maxEmailLen characters.');
      return;
    }
    if (phone.length > _maxPhoneLen) {
      _showMessage(
          context, 'Phone number must be at most $_maxPhoneLen digits.');
      return;
    }
    if (password.length > _maxPassLen) {
      _showMessage(
          context, 'Password must be at most $_maxPassLen characters.');
      return;
    }
    // 3. Formatos
    if (!_emailRegex.hasMatch(email)) {
      _showMessage(context, 'Please enter a valid email address.');
      return;
    }
    if (!_phoneRegex.hasMatch(phone)) {
      _showMessage(context, 'Phone number must contain digits only.');
      return;
    }
    // 4. Fecha
    DateTime dateOfBirth;
    try {
      dateOfBirth = DateTime.parse(dob);
    } catch (_) {
      _showMessage(context, 'Invalid date format. Use YYYY-MM-DD.');
      return;
    }
    // 5. Contraseñas
    if (password != confirmPassword) {
      _showMessage(context, 'Passwords do not match.');
      return;
    }

    final int phoneNumber = int.tryParse(phone)!;

    // 6. Llamada al repositorio
    isLoading = true;
    notifyListeners();
    try {
      final SignupResponse resp = await _repository.signUp(
        fullName: fullName,
        email: email,
        password: password,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
      );
      _showMessage(context, 'Sign up successful: ${resp.message}');
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      _showMessage(context, 'An error occurred: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showMessage(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
