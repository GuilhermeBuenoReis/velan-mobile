import 'package:flutter/material.dart';
import 'dart:math';

String createRandomId() {
  return Random().nextInt(999999999).toString();
}

class BenefitTone {
  final Color solid;
  final Color soft;
  final Color glow;

  BenefitTone({required this.solid, required this.soft, required this.glow});
}

class BenefitItem {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final BenefitTone tone;

  BenefitItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.tone,
  });
}

final benefits = [
  BenefitItem(
    id: createRandomId(),
    icon: Icons.bolt_rounded,
    title: 'Velocidade incomparável',
    description:
        'Interface otimizada para máxima performance. Carregamento instantâneo em qualquer dispositivo.',
    tone: BenefitTone(
      solid: Color.fromRGBO(76, 163, 176, 1),
      soft: Color.fromRGBO(76, 163, 176, .15),
      glow: Color.fromRGBO(76, 163, 176, .28),
    ),
  ),
  BenefitItem(
    id: createRandomId(),
    icon: Icons.shield_rounded,
    title: 'Segurança total',
    description:
        'Dados criptografados end-to-end, compliance com LGPD e certificações internacionais.',
    tone: BenefitTone(
      solid: Color.fromRGBO(107, 95, 209, 1),
      soft: Color.fromRGBO(107, 95, 209, .15),
      glow: Color.fromRGBO(107, 95, 209, .28),
    ),
  ),
  BenefitItem(
    id: createRandomId(),
    icon: Icons.groups_rounded,
    title: 'Colaboração em tempo real',
    description:
        'Equipes médicas conectadas. Compartilhe informações de forma segura e instantânea.',
    tone: BenefitTone(
      solid: Color.fromRGBO(142, 128, 240, 1),
      soft: Color.fromRGBO(142, 128, 240, .15),
      glow: Color.fromRGBO(142, 128, 240, .28),
    ),
  ),
  BenefitItem(
    id: createRandomId(),
    icon: Icons.schedule_rounded,
    title: 'Disponível 24/7',
    description:
        'Acesse suas informações a qualquer hora, de qualquer lugar. Sincronização automática em nuvem.',
    tone: BenefitTone(
      solid: Color.fromRGBO(236, 235, 244, 1),
      soft: Color.fromRGBO(236, 235, 244, .18),
      glow: Color.fromRGBO(236, 235, 244, .28),
    ),
  ),
  BenefitItem(
    id: createRandomId(),
    icon: Icons.bar_chart_rounded,
    title: 'Insights inteligentes',
    description:
        'Analytics avançados e relatórios personalizados para tomada de decisão baseada em dados.',
    tone: BenefitTone(
      solid: Color.fromRGBO(67, 163, 102, 1),
      soft: Color.fromRGBO(67, 163, 102, .15),
      glow: Color.fromRGBO(67, 163, 102, .28),
    ),
  ),
  BenefitItem(
    id: createRandomId(),
    icon: Icons.lock_rounded,
    title: 'Privacidade garantida',
    description:
        'Seus dados pertencem a você. Controle total sobre quem acessa suas informações.',
    tone: BenefitTone(
      solid: Color.fromRGBO(124, 110, 228, 1),
      soft: Color.fromRGBO(124, 110, 228, .15),
      glow: Color.fromRGBO(124, 110, 228, .28),
    ),
  ),
];

class WelcomeBenefits extends StatelessWidget {
  const WelcomeBenefits({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            children: [
              AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [
                          Color(0xFF6B5FD1),
                          Color(0xFF574ECC),
                          Color(0xFF4CA3B0),
                        ],
                      ).createShader(rect),
                      child: const Text(
                        'Por que escolher a Velan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tecnologia de ponta combinada com experiência do usuário excepcional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 1024
                      ? 3
                      : constraints.maxWidth >= 680
                      ? 2
                      : 1;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: .95,
                    ),
                    itemCount: benefits.length,
                    itemBuilder: (context, index) {
                      final b = benefits[index];
                      return _BenefitCard(item: b);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitCard extends StatefulWidget {
  final BenefitItem item;

  const _BenefitCard({required this.item});

  @override
  State<_BenefitCard> createState() => _BenefitCardState();
}

class _BenefitCardState extends State<_BenefitCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        transform: Matrix4.translationValues(0, hovering ? -8 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(
                context,
              ).colorScheme.surfaceVariant.withValues(alpha: .4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: .3),
          ),
        ),
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: hovering ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [item.tone.glow, Colors.transparent],
                    center: Alignment.topLeft,
                    radius: .8,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedScale(
                    scale: hovering ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: item.tone.soft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        children: [
                          AnimatedOpacity(
                            opacity: hovering ? .6 : 0,
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              decoration: BoxDecoration(
                                color: item.tone.glow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          Center(
                            child: Icon(
                              item.icon,
                              size: 28,
                              color: item.tone.solid,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
