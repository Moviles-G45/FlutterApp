import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
      child: Consumer<LoginViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFF067DC3),
            body: Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Welcome",
                  style: TextStyle(
                    fontSize: 28,
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
                        // Email Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            onChanged: vm.setEmail,
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.black54),
                              counterText: '',
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            obscureText: true,
                            onChanged: vm.setPassword,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.black54),
                              counterText: '',
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        vm.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "Log In",
                                onPressed: () => vm.login(context),
                              ),

                        const SizedBox(height: 10),

                        // Forgot Password
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/recover'),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Sign Up
                        CustomButton(
                          text: "Sign Up",
                          color: const Color(0xFF006994),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/signup'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
