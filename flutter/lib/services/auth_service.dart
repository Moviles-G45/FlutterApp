import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import '../firebase_options.dart'; // 🔹 Importa la configuración de Firebase

class AuthService {
  final String backendUrl =
      "http://localhost:8000/auth/login"; // 🔹 Endpoint del backend

  // 🔹 Método para iniciar sesión y obtener el token
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      // 🔹 Asegurar que Firebase está inicializado
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 🔹 Iniciar sesión con Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // 🔹 Obtener el idToken de Firebase
      String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) throw Exception("No se pudo obtener el idToken");

      // 🔹 Enviar el token al backend
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": idToken}),
      );

      // 🔹 Manejo de respuesta
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // 🔹 Retorna los datos del usuario
      } else {
        throw Exception("Error en login: ${response.body}");
      }
    } catch (e) {
      return null;
    }
  }
}
