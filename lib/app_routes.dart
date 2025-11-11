import 'package:flutter/cupertino.dart';
import 'package:velan_mobile/Screens/Auth/Pages/login_page.dart';
import 'package:velan_mobile/Screens/Auth/Pages/register_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
  };
}