import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/signup_response.dart';
import '../models/recover_response.dart';

class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;
  final String _baseUrl;

  AuthRepository({
    fb.FirebaseAuth? firebaseAuth,
    String? baseUrl,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _baseUrl = baseUrl ?? 'http://192.168.0.32:8000/auth';

  /// Sign in with Firebase, exchange token with backend, cache token, and return User.
  Future<User?> signIn(String email, String password) async {
    try {
      // 1. Firebase sign-in
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final idToken = await cred.user?.getIdToken();
      if (idToken == null) throw Exception('Unable to obtain idToken');

      // 2. Send token to backend
      final resp = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (resp.statusCode != 200) {
        throw Exception('Login failed: ${resp.statusCode}');
      }

      // 3. Parse response and cache token
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', idToken);

      return User.fromMap(data);
    } catch (_) {
      // swallow errors, return null to indicate failure
      return null;
    }
  }

  /// Sign up on backend.
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

    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (resp.statusCode != 200) {
      throw Exception('Signup failed: ${resp.statusCode}');
    }
    return SignupResponse.fromMap(jsonDecode(resp.body));
  }

  /// Request password recovery; email passed as query parameter.
  Future<RecoverResponse> recoverPassword(String email) async {
    final url = Uri.parse('$_baseUrl/recover?email=$email');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Recover failed: ${resp.body}');
    }
    return RecoverResponse.fromMap(jsonDecode(resp.body));
  }

  /// Sign out from Firebase and clear cached token.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  /// Get current Firebase ID token.
  Future<String> getIdToken({bool forceRefresh = false}) async {
    final fb.User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final String? token = await user.getIdToken(forceRefresh);
        return token ?? '';
      } catch (e) {
        return '';
      }
    }
    return '';
  }
}
