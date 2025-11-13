import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/App/Pages/Welcome/welcome_page.dart';
import 'package:velan_mobile/Screens/Auth/Pages/login_page.dart';
import 'package:velan_mobile/Screens/Auth/Pages/register_page.dart';
import 'package:velan_mobile/Screens/App/Pages/Dashboard/dashboard_page.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';

  static Map<String, WidgetBuilder> routes = {
    welcome: (_) => const WelcomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    dashboard: (_) => const DashboardPage(),
  };
}
