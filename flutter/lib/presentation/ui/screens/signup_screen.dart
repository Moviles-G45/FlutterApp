import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> handleSignup() async {
    setState(() => isLoading = true);

    final String fullName = fullNameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String dob = dobController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        dob.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage("Todos los campos son obligatorios.");
      setState(() => isLoading = false);
      return;
    }

    if (password != confirmPassword) {
      showMessage("Las contraseñas no coinciden.");
      setState(() => isLoading = false);
      return;
    }

    try {
      String formattedDob = "${dob}T00:00:00";

      final Map<String, dynamic> requestBody = {
        "full_name": fullName,
        "email": email,
        "password": password,
        "date_of_birth": formattedDob,
        "phone_number": int.tryParse(phone) ?? 0,
      };

      final response = await http.post(
        Uri.parse("http://localhost:8000/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        showMessage("Registro exitoso: ${responseData['message']}");
        Navigator.pushNamed(context, '/login');
      } else {
        showMessage("Error en el registro: ${response.body}");
      }
    } catch (e) {
      showMessage("Error de conexión. Inténtalo de nuevo.");
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
            "Create Account",
            style: TextStyle(
              fontSize: 26,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildTextField("Full Name", fullNameController),
                    const SizedBox(height: 10),
                    _buildTextField("Email", emailController),
                    const SizedBox(height: 10),
                    _buildTextField("Mobile Number", phoneController),
                    const SizedBox(height: 10),
                    _buildTextField(
                        "Date Of Birth (YYYY-MM-DD)", dobController),
                    const SizedBox(height: 10),
                    _buildTextField("Password", passwordController,
                        isPassword: true),
                    const SizedBox(height: 10),
                    _buildTextField(
                        "Confirm Password", confirmPasswordController,
                        isPassword: true),
                    const SizedBox(height: 20),
                    const Text(
                      "By continuing, you agree to",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const Text(
                      "Terms of Use and Privacy Policy.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Sign Up",
                            onPressed: handleSignup,
                          ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "Log In",
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
