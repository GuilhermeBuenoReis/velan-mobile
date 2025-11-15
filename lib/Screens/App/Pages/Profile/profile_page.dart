import 'package:flutter/material.dart';
import 'package:velan_mobile/Models/user.dart';
import 'package:velan_mobile/Screens/App/app_layout.dart';
import 'package:velan_mobile/Services/profile_api.dart';
import 'package:velan_mobile/Services/profile_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _typeController = TextEditingController();

  final _repository = ProfileRepository();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final user = await _repository.fetchProfile();
      _assignUser(user);
    } catch (e) {
      setState(() => _error = 'Não foi possível carregar seus dados.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _assignUser(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _typeController.text = user.type ?? '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final updated = await _repository.updateProfile(
        ProfilePayload(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          type: _typeController.text.trim().isEmpty
              ? null
              : _typeController.text.trim(),
        ),
      );
      if (!mounted) return;
      _assignUser(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _error = 'Erro ao salvar. Verifique os dados e tente novamente.',
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return AppLayout(
      breadcrumbs: const ['Perfil'],
      child: Container(
        color: const Color(0xFFF5F5F7),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _loading
                    ? const SizedBox(
                        height: 220,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Perfil',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Gerencie seu nome, e-mail e tipo de usuário.',
                              style: TextStyle(
                                color: c.onSurface.withOpacity(.7),
                              ),
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(.08),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.redAccent),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nome completo',
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Informe seu nome'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Informe seu e-mail';
                                if (!v.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _typeController,
                              decoration: const InputDecoration(
                                labelText: 'Tipo de usuário (opcional)',
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _saving ? null : _loadProfile,
                                  child: const Text('Recarregar'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: _saving ? null : _submit,
                                  child: _saving
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Salvar'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
