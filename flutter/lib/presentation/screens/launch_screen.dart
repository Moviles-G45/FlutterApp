import 'package:flutter/material.dart';
import '../../services/noti_test_service.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_button.dart';
import 'package:finances/config/theme/colors.dart';
import '../viewmodels/launch_viewmodel.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LaunchViewModel(),
      child: Consumer<LaunchViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.launchBack,
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
                    onPressed: () => viewModel.onLogin(context),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: "Sign Up",
                    color: AppColors.strongBlue,
                    onPressed: () => viewModel.onSignUp(context),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => viewModel.onRecover(context),
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
