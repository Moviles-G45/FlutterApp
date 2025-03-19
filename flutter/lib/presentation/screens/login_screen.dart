import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            CustomTextField(
                label: "Username Or Email", controller: emailController),
            const SizedBox(height: 10),
            CustomTextField(
                label: "Password",
                controller: passwordController,
                obscureText: true),
            const SizedBox(height: 20),
            CustomButton(
              text: "Log In",
              onPressed: () {
                // Aquí iría la lógica de autenticación
              },
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
            CustomButton(
              text: "Sign Up",
              onPressed: () => Navigator.pushNamed(context, '/signup'),
            ),
          ],
        ),
      ),
    );
  }
}
