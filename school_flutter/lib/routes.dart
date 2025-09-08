import 'package:flutter/material.dart';
import 'authentication/login.dart';
import 'authentication/register.dart';
import 'authentication/forgot_password.dart';

class Routes {
  static const String login = '/';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginPage(),
      register: (context) => const RegisterPage(),
      forgotPassword: (context) => const ForgotPasswordPage(),
    };
  }
}
