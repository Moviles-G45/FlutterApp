import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  final String backendUrl =
      "https://fastapi-service-185169107324.us-central1.run.app/auth/login";
  String? _token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("auth_token");
  }

  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      print("intentando");

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) throw Exception("No se pudo obtener el idToken");

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", idToken);
        _token = idToken;

        return data;
      } else {
        throw Exception("Error en login: ${response.body}");
      }
    } catch (e) {
      print("Error en el inicio de sesión: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }

  Future<String> getIdToken([bool forceRefresh = false]) async {
    if (_token != null && !forceRefresh) {
      return _token!;
    }
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final fresh = await user.getIdToken(forceRefresh) ?? "";
        _token = fresh;
        return fresh;
      } catch (e) {
        print("Error obteniendo el token: $e");
      }
    }
    return "";
  }
}
