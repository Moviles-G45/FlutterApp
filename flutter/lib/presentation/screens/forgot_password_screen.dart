import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // 🔹 Método para recuperar la contraseña
  Future<void> handleForgotPassword() async {
    setState(() => isLoading = true);

    final String email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage("Por favor, ingresa tu email.");
      setState(() => isLoading = false);
      return;
    }

    try {
      // 🔹 Hacer la solicitud al backend con el email en la URL
      final response = await http.post(
        Uri.parse("http://localhost:8000/auth/recover?email=$email"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        showMessage(responseData['message']);
      } else {
        showMessage("Error al enviar el correo. Inténtalo de nuevo.");
      }
    } catch (e) {
      showMessage("Error de conexión. Verifica tu conexión a internet.");
    }

    setState(() => isLoading = false);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF067DC3),
      body: Column(
        children: [
          const SizedBox(height: 80),
          const Text(
            "Forgot Your Password?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Color(0xFFB7D9EE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Type Your Email",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 15),

                  // 🔹 Campo de Email con Fondo Blanco y Bordes Redondeados
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "example@example.com",
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Botón "Send Link" con Loading
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Send Link",
                          onPressed: handleForgotPassword,
                        ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
