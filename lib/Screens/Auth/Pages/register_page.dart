import 'package:flutter/material.dart';
import 'package:velan_mobile/Screens/Auth/auth_layout.dart';
import 'package:velan_mobile/Services/auth_service.dart';
import 'package:velan_mobile/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final auth = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final typeController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool showPass = false;
  bool showConfirm = false;
  bool loading = false;
  bool acceptTerms = false;

  String role = "patient";

  String? errorMessage;
  bool successVisible = false;

  void handleRegister() async {
    setState(() {
      loading = true;
      errorMessage = null;
      successVisible = false;
    });

    try {
      await auth.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        type: typeController.text.trim(),
        role: role,
        password: passController.text.trim(),
        confirmPassword: confirmPassController.text.trim(),
      );

      setState(() {
        successVisible = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceAll("Exception:", "").trim();
      });
    }

    setState(() {
      loading = false;
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
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.red.withOpacity(.15),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),

            const SizedBox(height: 8),

            const Text("Nome completo", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Seu nome completo',
                filled: true,
                fillColor: Colors.white.withOpacity(.06),
              ),
            ),

            const SizedBox(height: 16),

            const Text("E-mail", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'seu@email.com',
                filled: true,
                fillColor: Colors.white.withOpacity(.06),
              ),
            ),

            const SizedBox(height: 16),

            const Text("Telefone", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                hintText: '(00) 00000-0000',
                filled: true,
                fillColor: Colors.white.withOpacity(.06),
              ),
            ),

            const SizedBox(height: 16),

            const Text("Tipo de usuário", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                hintText: 'Ex.: Clínica especializada',
                filled: true,
                fillColor: Colors.white.withOpacity(.06),
              ),
            ),

            const SizedBox(height: 16),

            const Text("Perfil de uso", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.06),
                borderRadius: BorderRadius.circular(6),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: role,
                  dropdownColor: const Color(0xFF202020),
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.white,
                  items: const [
                    DropdownMenuItem(
                        value: "patient", child: Text("Paciente")),
                    DropdownMenuItem(value: "doctor", child: Text("Médico")),
                    DropdownMenuItem(value: "clinic", child: Text("Clínica")),
                  ],
                  onChanged: (v) {
                    setState(() => role = v!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text("Senha", style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: passController,
                  obscureText: !showPass,
                  decoration: InputDecoration(
                    hintText: 'Mínimo 8 caracteres',
                    filled: true,
                    fillColor: Colors.white.withOpacity(.06),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => showPass = !showPass);
                  },
                  icon: Icon(
                    showPass ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text("Confirmar senha",
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: confirmPassController,
                  obscureText: !showConfirm,
                  decoration: InputDecoration(
                    hintText: 'Digite novamente',
                    filled: true,
                    fillColor: Colors.white.withOpacity(.06),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => showConfirm = !showConfirm);
                  },
                  icon: Icon(
                    showConfirm ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : handleRegister,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Registrar-se"),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.login),
                child: const Text(
                  "Já tem uma conta? Entre agora",
                  style: TextStyle(
                      color: Color(0xFF4CA3B0),
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
