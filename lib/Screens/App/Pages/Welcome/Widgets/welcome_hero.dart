import 'package:flutter/material.dart';

class WelcomeHero extends StatefulWidget {
  const WelcomeHero({super.key});

  @override
  State<WelcomeHero> createState() => _WelcomeHeroState();
}

class _WelcomeHeroState extends State<WelcomeHero>
    with TickerProviderStateMixin {
  late AnimationController leftGlowController;
  late AnimationController rightGlowController;
  late AnimationController card1Controller;
  late AnimationController card2Controller;
  late AnimationController card3Controller;

  @override
  void initState() {
    super.initState();

    leftGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    rightGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    card1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    card2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);

    card3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    leftGlowController.dispose();
    rightGlowController.dispose();
    card1Controller.dispose();
    card2Controller.dispose();
    card3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final double heroMinHeight = size.height < 760 ? 760 : size.height;
    final double glowTop = heroMinHeight * .25;
    final double glowBottom = heroMinHeight * .25;
    final double cardStackHeight = size.width < 640 ? 220 : 280;
    final double sideInset = size.width >= 900
        ? size.width * .12
        : size.width * .08;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.surface, c.background, c.secondary.withValues(alpha: .15)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: heroMinHeight),
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: leftGlowController,
              builder: (_, __) {
                final v = leftGlowController.value;
                return Positioned(
                  top: glowTop,
                  left: -80,
                  child: Container(
                    height: 320,
                    width: 320,
                    decoration: BoxDecoration(
                      color: c.primary.withValues(alpha: .28 + v * .17),
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 128,
                          color: c.primary.withValues(alpha: .28 + v * .17),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: rightGlowController,
              builder: (_, __) {
                final v = rightGlowController.value;
                return Positioned(
                  bottom: glowBottom,
                  right: -80,
                  child: Container(
                    height: 320,
                    width: 320,
                    decoration: BoxDecoration(
                      color: c.secondary.withValues(alpha: .28 + v * .2),
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 128,
                          color: c.secondary.withValues(alpha: .28 + v * .2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 800),
                        child: ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [
                              c.primary,
                              c.primaryContainer,
                              c.secondary,
                            ],
                          ).createShader(rect),
                          child: const Text(
                            'Velan',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'Cuidar, evoluir, simplificar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            color: c.onSurface.withValues(alpha: .9),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          'A próxima geração em gestão de saúde. Conecte pacientes, médicos e clínicas em uma plataforma inteligente e segura.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: c.onSurface.withValues(alpha: .7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 20,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _AnimatedButton(
                            label: 'Começar agora',
                            icon: Icons.arrow_right_alt_rounded,
                            gradient: LinearGradient(
                              colors: [c.primary, c.primaryContainer],
                            ),
                          ),
                          _OutlinedButton(
                            label: 'Ver demonstração',
                            icon: Icons.play_arrow_rounded,
                            color: c.secondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 80),
                      SizedBox(
                        height: cardStackHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: card1Controller,
                              builder: (_, __) {
                                final v = card1Controller.value;
                                return Positioned(
                                  left: sideInset,
                                  top: size.width < 640 ? 24 : 40,
                                  child: Transform.translate(
                                    offset: Offset(0, -20 * v),
                                    child: Transform.rotate(
                                      angle: (-2 + 4 * v) * 0.01745,
                                      child: _FloatingCard(
                                        color: c.primary,
                                        width: 160,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: card2Controller,
                              builder: (_, __) {
                                final v = card2Controller.value;
                                return Positioned(
                                  right: sideInset,
                                  top: size.width < 640 ? 48 : 70,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * v),
                                    child: Transform.rotate(
                                      angle: (2 - 4 * v) * 0.01745,
                                      child: _FloatingCard(
                                        color: c.secondary,
                                        width: 160,
                                        height: 120,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            AnimatedBuilder(
                              animation: card3Controller,
                              builder: (_, __) {
                                final v = card3Controller.value;
                                return Positioned(
                                  top: size.width < 640 ? 90 : 130,
                                  left: 0,
                                  right: 0,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Transform.scale(
                                      scale: 1 + (v * .05),
                                      child: Transform.translate(
                                        offset: Offset(0, -15 * v),
                                        child: _FloatingCard(
                                          color: c.tertiary,
                                          width: 190,
                                          height: 140,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [c.background, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
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

class _AnimatedButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Gradient gradient;

  const _AnimatedButton({
    required this.label,
    required this.icon,
    required this.gradient,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: hovering ? 1.05 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: widget.gradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _OutlinedButton({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  State<_OutlinedButton> createState() => _OutlinedButtonState();
}

class _OutlinedButtonState extends State<_OutlinedButton> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedScale(
        scale: hovering ? 1.05 : 1,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: widget.color, width: 2),
            color: hovering
                ? widget.color.withValues(alpha: .1)
                : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.color, size: 22),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _FloatingCard({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: .18), color.withValues(alpha: .1)],
        ),
        border: Border.all(color: color.withValues(alpha: .3)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
        backgroundBlendMode: BlendMode.overlay,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(
              color: c.onSurface.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            width: width * .7,
            decoration: BoxDecoration(
              color: c.onSurface.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 6,
            width: width * .55,
            decoration: BoxDecoration(
              color: c.onSurface.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
