import 'package:flutter/material.dart';

class SocialLink {
  final String label;
  final String href;

  SocialLink(this.label, this.href);
}

class FooterLink {
  final String label;
  final String href;

  FooterLink(this.label, this.href);
}

final socialLinks = [
  SocialLink('twitter', '/social/twitter'),
  SocialLink('linkedin', '/social/linkedin'),
  SocialLink('instagram', '/social/instagram'),
];

final productLinks = [
  FooterLink('Recursos', '/features'),
  FooterLink('Preços', '/pricing'),
  FooterLink('Segurança', '/security'),
  FooterLink('Atualizações', '/updates'),
  FooterLink('Roadmap', '/roadmap'),
];

final companyLinks = [
  FooterLink('Sobre', '/about'),
  FooterLink('Blog', '/blog'),
  FooterLink('Carreiras', '/careers'),
  FooterLink('Imprensa', '/press'),
  FooterLink('Parceiros', '/partners'),
];

final legalLinks = [
  FooterLink('Política de privacidade', '/privacy-policy'),
  FooterLink('Termos de uso', '/terms-of-use'),
  FooterLink('Cookies', '/cookies'),
];

class WelcomeFooter extends StatelessWidget {
  const WelcomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceVariant,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: 600,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(300),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6B5FD1).withValues(alpha: .35),
                          const Color(0xFF4CA3B0).withValues(alpha: .35),
                        ],
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
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
                          'Pronto para transformar sua saúde?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Junte-se a milhares de profissionais e pacientes que já confiam na Velan para gerenciar sua saúde de forma inteligente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: .7),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _AnimatedButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: .4),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isLarge = constraints.maxWidth >= 900;
                  final isMedium = constraints.maxWidth >= 600;

                  return GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isLarge
                          ? 4
                          : isMedium
                          ? 2
                          : 1,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 40,
                      childAspectRatio: isLarge ? 1.4 : 1.1,
                    ),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) => const LinearGradient(
                              colors: [Color(0xFF6B5FD1), Color(0xFF4CA3B0)],
                            ).createShader(rect),
                            child: const Text(
                              'Velan',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'A próxima geração em gestão de saúde. Tecnologia que cuida de você.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: .7),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: socialLinks
                                .map(
                                  (e) => Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    height: 42,
                                    width: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).dividerColor.withValues(alpha: .5),
                                      ),
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF6B5FD1),
                                            Color(0xFF4CA3B0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                      _FooterSection(title: 'Produto', links: productLinks),
                      _FooterSection(title: 'Empresa', links: companyLinks),
                      _ContactSection(),
                    ],
                  );
                },
              ),
            ),
          ),
          Divider(
            color: Theme.of(context).dividerColor.withValues(alpha: .4),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1300),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 700;
                  final textStyle = TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: .7),
                  );
                  final legalLinksWrap = Wrap(
                    spacing: 24,
                    runSpacing: 8,
                    children: legalLinks
                        .map(
                          (e) => Text(
                            e.label,
                            style: textStyle,
                          ),
                        )
                        .toList(),
                  );
                  final copyright = Text(
                    '© $year Velan. Todos os direitos reservados.',
                    style: textStyle,
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        copyright,
                        const SizedBox(height: 12),
                        legalLinksWrap,
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      copyright,
                      legalLinksWrap,
                    ],
                  );
                },
              ),
            ),
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color(0xFF6B5FD1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final String title;
  final List<FooterLink> links;

  const _FooterSection({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: .6),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: links
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    e.label,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .7),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contato'.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: c.onSurface.withValues(alpha: .6),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.mail_rounded, size: 18, color: c.primary),
            const SizedBox(width: 8),
            Text(
              'contato@velan.com',
              style: TextStyle(
                fontSize: 14,
                color: c.onSurface.withValues(alpha: .7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(Icons.phone_rounded, size: 18, color: c.primary),
            const SizedBox(width: 8),
            Text(
              '+55 11 9999-9999',
              style: TextStyle(
                fontSize: 14,
                color: c.onSurface.withValues(alpha: .7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 18, color: c.primary),
            const SizedBox(width: 8),
            Text(
              'São Paulo, SP - Brasil',
              style: TextStyle(
                fontSize: 14,
                color: c.onSurface.withValues(alpha: .7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnimatedButton extends StatefulWidget {
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
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF6B5FD1), Color(0xFF4CA3B0)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6B5FD1).withValues(alpha: .3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Começar gratuitamente',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_right_alt_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
