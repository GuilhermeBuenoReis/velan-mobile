import 'package:flutter/material.dart';

class WelcomeTestimonials extends StatelessWidget {
  const WelcomeTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final testimonials = [
      {
        'name': 'Dr. Ana Carolina',
        'role': 'Cardiologista',
        'avatar':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&h=150&fit=crop',
        'quote':
            'A Velan revolucionou a forma como gerencio minha clínica. Agora tenho mais tempo para focar no que realmente importa: meus pacientes.',
        'base': const Color.fromRGBO(107, 95, 209, 1),
        'soft': const Color.fromRGBO(107, 95, 209, .16),
        'glow': const Color.fromRGBO(107, 95, 209, .30),
      },
      {
        'name': 'Roberto Silva',
        'role': 'Paciente',
        'avatar':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop',
        'quote':
            'Nunca foi tão fácil acompanhar minha saúde. Todo meu histórico médico está sempre disponível, em qualquer lugar.',
        'base': const Color.fromRGBO(76, 163, 176, 1),
        'soft': const Color.fromRGBO(76, 163, 176, .16),
        'glow': const Color.fromRGBO(76, 163, 176, .28),
      },
      {
        'name': 'Dra. Mariana Costa',
        'role': 'Clínica Médica',
        'avatar':
            'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150&h=150&fit=crop',
        'quote':
            'A interface é intuitiva e elegante. Meus pacientes adoram a facilidade de agendamento e o acompanhamento em tempo real.',
        'base': const Color.fromRGBO(89, 193, 120, 1),
        'soft': const Color.fromRGBO(89, 193, 120, .16),
        'glow': const Color.fromRGBO(89, 193, 120, .28),
      },
    ];

    final trustIndicators = [
      {'value': '10k+', 'label': 'Consultas realizadas'},
      {'value': '500+', 'label': 'Profissionais ativos'},
      {'value': '98%', 'label': 'Satisfação'},
      {'value': '24/7', 'label': 'Suporte'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      color: c.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Confiado por profissionais',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                'Veja o que médicos e pacientes estão falando sobre a Velan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onSurface.withValues(alpha: .6),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (_, box) {
                  final mobile = box.maxWidth < 900;
                  return GridView.builder(
                    itemCount: testimonials.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: mobile ? 1 : 3,
                      mainAxisSpacing: 28,
                      crossAxisSpacing: 28,
                      childAspectRatio: .95,
                    ),
                    itemBuilder: (_, i) {
                      final t = testimonials[i];
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: c.outlineVariant.withValues(alpha: .6),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              c.surface,
                              c.surfaceVariant.withValues(alpha: .7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: c.shadow.withValues(alpha: .1),
                              blurRadius: 18,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: t['soft'] as Color,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.format_quote_rounded,
                                color: t['base'] as Color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '"${t['quote']}"',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.45,
                                color: c.onSurface.withValues(alpha: .9),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 48,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        border: Border.all(
                                          width: 2,
                                          color: t['base'] as Color,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            t['avatar'] as String,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (t['glow'] as Color)
                                                  .withValues(alpha: .5),
                                              blurRadius: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t['name'] as String,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      t['role'] as String,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: c.onSurface.withValues(
                                          alpha: .6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: c.outlineVariant.withValues(alpha: .5),
                    ),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width >= 900
                        ? 4
                        : width >= 600
                            ? 2
                            : 1;
                    final aspectRatio =
                        crossAxisCount == 1 ? 3.2 : 1.6;

                    return GridView.builder(
                      itemCount: trustIndicators.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: aspectRatio,
                      ),
                      itemBuilder: (_, i) {
                        final s = trustIndicators[i];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) => LinearGradient(
                                colors: [c.primary, c.secondary],
                              ).createShader(rect),
                              child: Text(
                                s['value'] as String,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s['label'] as String,
                              style: TextStyle(
                                color: c.onSurface.withValues(alpha: .6),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
