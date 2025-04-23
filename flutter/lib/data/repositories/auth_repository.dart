import 'dart:convert';
import 'package:http/http.dart' as http;
import '/services/auth_service.dart';
import '../models/user_model.dart';
import '../models/signup_response.dart';
import '../models/recover_response.dart';

class AuthRepository {
  final AuthService _authService;
  final String _baseUrl;

  AuthRepository({AuthService? authService, String? baseUrl})
      : _authService = authService ?? AuthService(),
        _baseUrl = baseUrl ?? 'http://localhost:8000/auth';

  // Sign In
  Future<User?> signIn(String email, String password) async {
    final data = await _authService.signIn(email, password);
    if (data != null && data.containsKey('email')) {
      return User.fromMap(data);
    }
    return null;
  }

  // Sign Up
  Future<SignupResponse> signUp({
    required String fullName,
    required String email,
    required String password,
    required DateTime dateOfBirth,
    required int phoneNumber,
  }) async {
    final url = Uri.parse('$_baseUrl/signup');
    final body = jsonEncode({
      'full_name': fullName,
      'email': email,
      'password': password,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'phone_number': phoneNumber,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return SignupResponse.fromMap(data);
    } else {
      throw Exception(
          'An error occurred in the process: ${response.statusCode}');
    }
  }

  // Recover Password
  Future<RecoverResponse> recoverPassword(String email) async {
    final url = Uri.parse('$_baseUrl/recover?email=$email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return RecoverResponse.fromMap(data);
    } else {
      throw Exception(
          'Error sending recovery email (${response.statusCode}): ${response.body}');
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // Get ID Token
  Future<String> getIdToken({bool forceRefresh = false}) {
    return _authService.getIdToken(forceRefresh);
  }
}
