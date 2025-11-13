import 'package:flutter/material.dart';
import 'package:velan_mobile/app_routes.dart';

class WelcomeNavbar extends StatefulWidget {
  final double scrollOffset;

  const WelcomeNavbar({super.key, required this.scrollOffset});

  @override
  State<WelcomeNavbar> createState() => _WelcomeNavbarState();
}

class _WelcomeNavbarState extends State<WelcomeNavbar> {
  bool isOpen = false;

  final navLinks = [
    {'label': 'Features', 'href': '#features'},
    {'label': 'Plans', 'href': '#plans'},
    {'label': 'About', 'href': '#about'},
    {'label': 'Contact', 'href': '#contact'},
  ];

  final authLinks = {'login': AppRoutes.login, 'register': AppRoutes.register};

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final isDesktopWidth = MediaQuery.of(context).size.width >= 800;
    final double scroll = widget.scrollOffset;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.transparent,
              const Color.fromRGBO(14, 13, 19, .92),
              (scroll / 100).clamp(0, 1),
            ),
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(
                  227,
                  225,
                  236,
                  (scroll / 100 * 0.1).clamp(0, 0.1),
                ),
              ),
            ),
          ),
          child: SizedBox(
            height: kToolbarHeight + 20,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: ShaderMask(
                          shaderCallback: (rect) => LinearGradient(
                            colors: [c.primary, c.secondary],
                          ).createShader(rect),
                          child: const Text(
                            'Velan',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: LayoutBuilder(
                            builder: (_, box) {
                              final isWide = box.maxWidth >= 800;
                              if (isWide && isOpen) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    setState(() => isOpen = false);
                                  }
                                });
                              }

                              if (isWide) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Wrap(
                                      spacing: 28,
                                      children: navLinks
                                          .map(
                                            (link) => Text(
                                              link['label']!,
                                              style: TextStyle(
                                                color: c.onSurface.withValues(
                                                  alpha: .7,
                                                ),
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(width: 16),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          authLinks['login']!,
                                        );
                                      },
                                      child: Text(
                                        'Entrar',
                                        style: TextStyle(color: c.onSurface),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          authLinks['register']!,
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [c.primary, c.secondary],
                                          ),
                                        ),
                                        child: const Text(
                                          'Começar grátis',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              return IconButton(
                                onPressed: () {
                                  setState(() => isOpen = !isOpen);
                                },
                                icon: Icon(
                                  isOpen
                                      ? Icons.close_rounded
                                      : Icons.menu_rounded,
                                  color: c.onSurface,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!isDesktopWidth)
          Container(
            color: c.surface,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: WelcomeNavbarMenu(
                  open: isOpen,
                  navLinks: navLinks,
                  authLinks: authLinks,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class WelcomeNavbarMenu extends StatelessWidget {
  final bool open;
  final List<Map<String, String>> navLinks;
  final Map<String, String> authLinks;

  const WelcomeNavbarMenu({
    super.key,
    required this.open,
    required this.navLinks,
    required this.authLinks,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    if (!open) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.outline.withValues(alpha: .3))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...navLinks.map(
            (link) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                link['label']!,
                style: TextStyle(
                  color: c.onSurface.withValues(alpha: .7),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, authLinks['login']!);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: c.outline),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text('Entrar', style: TextStyle(color: c.onSurface)),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, authLinks['register']!);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [c.primary, c.secondary]),
              ),
              child: const Center(
                child: Text(
                  'Começar grátis',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
