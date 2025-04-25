import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '/presentation/viewmodels/launch_viewmodel.dart';
import '../widgets/custom_button.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  Future<void> _checkAndNavigate(BuildContext context, String route) async {
    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

    final result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: const Text('No internet. Please try again.'),
          actions: [
            TextButton(
              onPressed: () =>
                  ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LaunchViewModel(),
      child: Consumer<LaunchViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png', height: 180),
                  const SizedBox(height: 20),
                  const Text(
                    "Spend wisely, save effortlessly.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: "Log In",
                    color: const Color(0xFF006994),
                    onPressed: () => _checkAndNavigate(context, '/login'),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: "Sign Up",
                    color: Colors.indigo,
                    onPressed: () => _checkAndNavigate(context, '/signup'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => _checkAndNavigate(context, '/recover'),
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
