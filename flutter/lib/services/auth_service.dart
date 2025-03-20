import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String backendUrl = "http://127.0.0.1:8000/auth/login";

  // 🔹 Método para iniciar sesión y guardar el token
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {

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

        // 🔹 Guardar token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", idToken);

        return data; // 🔹 Retorna los datos del usuario
      } else {
        throw Exception("Error en login: ${response.body}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // 🔹 Método para cerrar sesión y borrar el token
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token"); // 🔹 Eliminar token guardado
  }

  // 🔹 Método para obtener el token almacenado
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }
}
