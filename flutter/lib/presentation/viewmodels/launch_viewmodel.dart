import 'package:flutter/material.dart';

class LaunchViewModel extends ChangeNotifier {
  void onLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  void onSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void onRecover(BuildContext context) {
    Navigator.pushNamed(context, '/recover');
  }
}
