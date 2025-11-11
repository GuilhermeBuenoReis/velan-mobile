import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class AuthSimpleLayout extends StatefulWidget {
  final Widget child;
  final String? title;
  final String? description;

  const AuthSimpleLayout({
    super.key,
    required this.child,
    this.title,
    this.description,
  });

  @override
  State<AuthSimpleLayout> createState() => _AuthSimpleLayoutState();
}

class _AuthSimpleLayoutState extends State<AuthSimpleLayout>
    with TickerProviderStateMixin {
  late final AnimationController glowA;
  late final AnimationController glowB;
  late final AnimationController orbit;

  @override
  void initState() {
    super.initState();
    glowA = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat(reverse: true);
    glowB = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
    orbit = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    glowA.dispose();
    glowB.dispose();
    orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surface = const Color(0xFF0F0F11);
    final bg = const Color(0xFF0B0B0C);
    final primary = const Color(0xFF6B5FD1);
    final accent = const Color(0xFF4CA3B0);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, c) {
          final large = c.maxWidth >= 1024;

          return Row(
            children: [
              if (large)
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              surface,
                              bg,
                              accent.withValues(alpha: 0.24),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: glowA,
                        builder: (_, __) {
                          return Positioned(
                            left: c.maxWidth * 0.18 + glowA.value * 40,
                            top: c.maxHeight * 0.2 + glowA.value * 30,
                            child: Container(
                              width: 280 + glowA.value * 40,
                              height: 280 + glowA.value * 40,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.26),
                                shape: BoxShape.circle,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                                child: const SizedBox(),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: glowB,
                        builder: (_, __) {
                          return Positioned(
                            right: c.maxWidth * 0.14 + glowB.value * 30,
                            bottom: c.maxHeight * 0.18 + glowB.value * 50,
                            child: Container(
                              width: 280 + glowB.value * 60,
                              height: 280 + glowB.value * 60,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.24),
                                shape: BoxShape.circle,
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                                child: const SizedBox(),
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: Center(
                          child: AnimatedBuilder(
                            animation: orbit,
                            builder: (_, __) {
                              return Transform.rotate(
                                angle: orbit.value * 2 * pi,
                                child: SizedBox(
                                  width: 320,
                                  height: 320,
                                  child: Stack(
                                    children: List.generate(6, (i) {
                                      final angle = i * 60 * pi / 180;
                                      final r = 150.0;
                                      final x = r * cos(angle);
                                      final y = r * sin(angle);

                                      final color = i % 3 == 0
                                          ? primary
                                          : i % 3 == 1
                                          ? accent
                                          : const Color(0xFF59C178);

                                      return Positioned(
                                        left: 160 + x - 32,
                                        top: 160 + y - 32,
                                        child: AnimatedScale(
                                          scale: 1.0 + (sin(orbit.value * 4 + (i * 0.5)) * 0.2),
                                          duration: const Duration(milliseconds: 500),
                                          child: Container(
                                            width: 64,
                                            height: 64,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.08),
                                              ),
                                              gradient: LinearGradient(
                                                colors: [
                                                  color.withValues(alpha: 0.18),
                                                  color.withValues(alpha: 0.18),
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottomInset + 32),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              surface.withValues(alpha: 0.85),
                              surface.withValues(alpha: 0.75),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 40,
                              color: primary.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (r) => LinearGradient(
                                colors: [primary, accent],
                              ).createShader(r),
                              child: const Text(
                                'Velan',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Cuidar, evoluir, simplificar.',
                              style: TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 28),
                            if (widget.title != null)
                              Text(
                                widget.title!,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            if (widget.description != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 20),
                                child: Text(
                                  widget.description!,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            widget.child,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AuthSplitLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? description;

  const AuthSplitLayout({
    super.key,
    required this.child,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF0C0C0D);
    final surface = const Color(0xFF1A1A1C);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, c) {
          final large = c.maxWidth >= 1024;

          return Row(
            children: [
              if (large)
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        right: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Velan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '"Cuidar, evoluir, simplificar."',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Equipe Velan",
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottomInset + 20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!large)
                              const Text(
                                "Velan",
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            if (!large) const SizedBox(height: 12),
                            if (title != null)
                              Text(
                                title!,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            if (description != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 20),
                                child: Text(
                                  description!,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            child,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
