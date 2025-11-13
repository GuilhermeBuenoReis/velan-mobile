import 'package:flutter/material.dart';
import 'dart:math';

String createRandomId() => Random().nextInt(999999999).toString();

class StepItem {
  final String id;
  final IconData icon;
  final String title;
  final String description;
  final Color solid;
  final Color soft;
  final Color glow;

  StepItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    required this.solid,
    required this.soft,
    required this.glow,
  });
}

final steps = [
  StepItem(
    id: createRandomId(),
    icon: Icons.calendar_today_rounded,
    title: 'Agende com facilidade',
    description:
        'Sistema inteligente de agendamentos que se adapta à sua rotina e disponibilidade.',
    solid: const Color.fromRGBO(107, 95, 209, 1),
    soft: const Color.fromRGBO(107, 95, 209, .16),
    glow: const Color.fromRGBO(107, 95, 209, .28),
  ),
  StepItem(
    id: createRandomId(),
    icon: Icons.dashboard_rounded,
    title: 'Gerencie sua clínica',
    description:
        'Painel completo para profissionais com métricas, histórico e ferramentas de gestão.',
    solid: const Color.fromRGBO(76, 163, 176, 1),
    soft: const Color.fromRGBO(76, 163, 176, .16),
    glow: const Color.fromRGBO(76, 163, 176, .28),
  ),
  StepItem(
    id: createRandomId(),
    icon: Icons.monitor_heart_rounded,
    title: 'Acompanhe sua saúde',
    description:
        'Histórico médico completo, exames e evolução de tratamentos em um só lugar.',
    solid: const Color.fromRGBO(89, 193, 120, 1),
    soft: const Color.fromRGBO(89, 193, 120, .16),
    glow: const Color.fromRGBO(89, 193, 120, .28),
  ),
];

class WelcomeHowItWorks extends StatelessWidget {
  const WelcomeHowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      color: c.background,
      padding: const EdgeInsets.symmetric(vertical: 80),
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
                      shaderCallback: (rect) => LinearGradient(
                        colors: [c.primary, c.secondary],
                      ).createShader(rect),
                      child: const Text(
                        'Como funciona',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Três passos simples para transformar sua experiência em saúde',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: c.onSurface.withValues(alpha: .7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 56),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWide ? 3 : 1,
                      crossAxisSpacing: 28,
                      mainAxisSpacing: 28,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: steps.length,
                    itemBuilder: (context, index) {
                      final step = steps[index];
                      return _StepCard(
                        index: index,
                        item: step,
                        showConnector: isWide && index < steps.length - 1,
                      );
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

class _StepCard extends StatefulWidget {
  final int index;
  final StepItem item;
  final bool showConnector;

  const _StepCard({
    required this.index,
    required this.item,
    required this.showConnector,
  });

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final c = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            transform: Matrix4.translationValues(0, hovering ? -8 : 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: [c.surface, c.surfaceVariant.withValues(alpha: .5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: c.outline.withValues(alpha: .4)),
            ),
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: hovering ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [item.glow, Colors.transparent],
                        center: const Alignment(0, -1),
                        radius: 1,
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
                        scale: hovering ? 1.1 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: item.soft,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: AnimatedOpacity(
                                  opacity: hovering ? .5 : 0,
                                  duration: const Duration(milliseconds: 400),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: item.glow,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  item.icon,
                                  size: 32,
                                  color: item.solid,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
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
                          fontSize: 15,
                          color: c.onSurface.withValues(alpha: .7),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 28,
                  top: 24,
                  child: Text(
                    '${widget.index + 1}',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: c.onSurface.withValues(alpha: .06),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 3,
                  child: AnimatedOpacity(
                    opacity: hovering ? 1 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            item.glow,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.showConnector)
            Positioned(
              right: -16,
              top: 0,
              bottom: 0,
              child: Container(
                width: 32,
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 2,
                  width: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        c.onSurface.withValues(alpha: .1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
