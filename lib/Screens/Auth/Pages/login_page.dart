import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/Auth/auth_layout.dart';
import 'package:velan_mobile/Services/auth_service.dart';
import 'package:velan_mobile/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool showPassword = false;
  bool loading = false;
  String? errorMessage;

  void handleLogin() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      await auth.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.appointment);
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll("Exception:", "").trim();
      });
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthSimpleLayout(
      title: 'Bem-vindo de volta',
      description: 'Entre para continuar cuidando da sua saúde',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null)
            Text(errorMessage!, style: const TextStyle(color: Colors.redAccent)),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'seu@email.com'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: const InputDecoration(hintText: '••••••••'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: loading ? null : handleLogin,
              child:
                  loading ? const CircularProgressIndicator() : const Text('Entrar'),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text('Não tem uma conta? Crie agora'),
          ),
        ],
      ),
    );
  }
}
