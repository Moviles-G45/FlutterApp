import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 120), // Agrega tu logo
            const SizedBox(height: 20),
            const Text("Spend wisely, save effortlessly.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 40),
            CustomButton(
              text: "Log In",
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Sign Up",
              onPressed: () => Navigator.pushNamed(context, '/signup'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
