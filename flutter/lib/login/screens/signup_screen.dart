import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              CustomTextField(
                  label: "Full Name", controller: fullNameController),
              CustomTextField(label: "Email", controller: emailController),
              CustomTextField(
                  label: "Mobile Number", controller: phoneController),
              CustomTextField(
                  label: "Date Of Birth", controller: dobController),
              CustomTextField(
                  label: "Password",
                  controller: passwordController,
                  obscureText: true),
              CustomTextField(
                  label: "Confirm Password",
                  controller: confirmPasswordController,
                  obscureText: true),
              const SizedBox(height: 20),
              CustomButton(
                text: "Sign Up",
                onPressed: () {
                  // Aquí iría la lógica de registro
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
