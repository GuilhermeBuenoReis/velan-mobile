import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/Auth/auth_layout.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final typeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String role = 'patient';
  bool showPassword = false;
  bool showConfirm = false;
  bool acceptTerms = false;
  bool loading = false;
  bool successVisible = false;
  String? errorMessage;

  void handleRegister() async {
    setState(() {
      loading = true;
      errorMessage = null;
      successVisible = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        typeController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Preencha todos os campos.';
        loading = false;
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = 'As senhas precisam coincidir.';
        loading = false;
      });
      return;
    }

    if (!acceptTerms) {
      setState(() {
        errorMessage = 'Você precisa aceitar os termos.';
        loading = false;
      });
      return;
    }

    setState(() {
      loading = false;
      successVisible = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          successVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthSimpleLayout(
      title: 'Crie sua conta',
      description: 'Simplifique sua rotina médica e evolua com a Velan.',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text('Nome completo', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Seu nome completo',
                filled: true,
                fillColor: Colors.white.withValues(alpha: .06),
              ),
            ),
            const SizedBox(height: 16),
            const Text('E-mail', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'seu@email.com',
                filled: true,
                fillColor: Colors.white.withValues(alpha: .06),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Telefone', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: '(00) 00000-0000',
                filled: true,
                fillColor: Colors.white.withValues(alpha: .06),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tipo de usuário', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                hintText: 'Ex.: Clínica especializada',
                filled: true,
                fillColor: Colors.white.withValues(alpha: .06),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Perfil de uso', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: role,
                  items: const [
                    DropdownMenuItem(value: 'patient', child: Text('Paciente')),
                    DropdownMenuItem(value: 'doctor', child: Text('Médico')),
                    DropdownMenuItem(value: 'clinic', child: Text('Clínica')),
                  ],
                  onChanged: (v) {
                    setState(() {
                      role = v!;
                    });
                  },
                  dropdownColor: const Color(0xFF202020),
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Senha', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    hintText: 'Mínimo 8 caracteres',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: .06),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Confirmar senha', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: confirmPasswordController,
                  obscureText: !showConfirm,
                  decoration: InputDecoration(
                    hintText: 'Digite a senha novamente',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: .06),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    showConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      showConfirm = !showConfirm;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: acceptTerms,
                  onChanged: (v) {
                    setState(() {
                      acceptTerms = v ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'Aceito os termos de uso e políticas de privacidade.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .7),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            if (errorMessage != null)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.redAccent.withValues(alpha: .3)),
                  color: Colors.redAccent.withValues(alpha: .1),
                ),
                child: Text(
                  errorMessage!,
                  style:
                  const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : handleRegister,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                  child: Center(
                    child: successVisible
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Conta criada!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                        : loading
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2),
                    )
                        : const Text(
                      'Registrar-se',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Já tem uma conta? Entre agora',
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
      ),
    );
  }
}
