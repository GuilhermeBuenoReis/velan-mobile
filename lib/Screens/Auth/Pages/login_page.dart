import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/Auth/auth_layout.dart';
import 'package:velan_mobile/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;
  bool remember = false;
  bool loading = false;
  String? errorMessage;
  String? statusMessage;

  void handleLogin() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Preencha os campos corretamente.';
        loading = false;
      });
      return;
    }

    setState(() {
      loading = false;
      statusMessage = 'Login realizado com sucesso!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthSimpleLayout(
      title: 'Bem-vindo de volta',
      description: 'Entre para continuar cuidando da sua saúde',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (statusMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent.withValues(alpha: .3)),
                color: Colors.greenAccent.withValues(alpha: .1),
              ),
              child: Text(statusMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 14)),
            ),
          const SizedBox(height: 20),
          const Text(
            'E-mail',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'seu@email.com',
              filled: true,
              fillColor: Colors.white.withValues(alpha: .06),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Senha',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: .06),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (v) {
                  setState(() {
                    remember = v ?? false;
                  });
                },
              ),
              const SizedBox(width: 4),
              const Text('Lembrar de mim',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Esqueci minha senha',
                  style: TextStyle(
                    color: Color(0xFF4CA3B0),
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withValues(alpha: .3)),
                color: Colors.redAccent.withValues(alpha: .1),
              ),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: loading ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6B5FD1),
                      Color(0xFF4CA3B0),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: loading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Entrar',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Container(height: 1, color: Colors.white24)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('ou', style: TextStyle(color: Colors.white70)),
              ),
              Expanded(child: Container(height: 1, color: Colors.white24)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white24),
                backgroundColor: Colors.white.withValues(alpha: .06),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.account_circle),
                  SizedBox(width: 8),
                  Text('Entrar com Google'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.register);
              },
              child: const Text(
                'Não tem uma conta? Crie agora',
                style: TextStyle(
                  color: Color(0xFF4CA3B0),
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
