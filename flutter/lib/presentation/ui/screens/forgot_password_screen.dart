import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/presentation/viewmodels/forgot_password_viewmodel.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  Future<void> _checkAndPerform(
      BuildContext context, VoidCallback action) async {
    // Hide any existing banner
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      // No internet: show banner
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text('No internet. Please try again.'),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('CLOSE'),
            ),
          ],
        ),
      );
    } else {
      // Connected: perform the action
      action();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ForgotPasswordViewModel>(
      create: (_) => ForgotPasswordViewModel(),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: const Color(0xFF067DC3),
            body: Column(
              children: [
                const SizedBox(height: 60),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => _checkAndPerform(
                      context,
                      () => Navigator.pushNamed(context, '/login'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
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
                        // Label
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Type Your Email",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // Email field
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            onChanged: vm.setEmail,
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "example@example.com",
                              hintStyle: TextStyle(color: Colors.black54),
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Send Link button / Loading
                        vm.isLoading
                            ? const CircularProgressIndicator()
                            : CustomButton(
                                text: "Send Link",
                                onPressed: () => _checkAndPerform(
                                  context,
                                  () => vm.recover(context),
                                ),
                              ),
                        const SizedBox(height: 20),
                        // Navigate to signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () => _checkAndPerform(
                                context,
                                () => Navigator.pushNamed(context, '/signup'),
                              ),
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
        },
      ),
    );
  }
}
