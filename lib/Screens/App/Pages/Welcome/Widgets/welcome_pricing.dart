import 'package:flutter/material.dart';

class WelcomePricing extends StatelessWidget {
  const WelcomePricing({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final plans = [
      {
        'name': 'Starter',
        'price': 'R\$ 49',
        'period': '/mês',
        'description': 'Perfeito para profissionais independentes',
        'features': [
          'Até 50 pacientes',
          'Agendamento online',
          'Histórico médico digital',
          'Suporte por email',
          'App móvel básico',
        ],
        'highlighted': false,
        'tone': {
          'base': const Color.fromRGBO(107, 95, 209, 1),
          'soft': const Color.fromRGBO(107, 95, 209, .18),
          'shadow': const Color.fromRGBO(107, 95, 209, .28),
        },
      },
      {
        'name': 'Pro',
        'price': 'R\$ 149',
        'period': '/mês',
        'description': 'Ideal para clínicas em crescimento',
        'features': [
          'Pacientes ilimitados',
          'Agendamento inteligente',
          'Prontuário eletrônico completo',
          'Relatórios e analytics',
          'Suporte prioritário 24/7',
          'Integração com laboratórios',
          'API personalizada',
        ],
        'highlighted': true,
        'badge': 'Mais popular',
        'tone': {
          'base': const Color.fromRGBO(76, 163, 176, 1),
          'soft': const Color.fromRGBO(76, 163, 176, .2),
          'shadow': const Color.fromRGBO(76, 163, 176, .32),
        },
      },
      {
        'name': 'Clinic',
        'price': 'R\$ 399',
        'period': '/mês',
        'description': 'Solução completa para grandes clínicas',
        'features': [
          'Tudo do plano Pro',
          'Multi-localização',
          'Gestão de equipe',
          'Telemedicina integrada',
          'Faturamento automático',
          'Customização avançada',
          'Gerente de conta dedicado',
        ],
        'highlighted': false,
        'tone': {
          'base': const Color.fromRGBO(89, 193, 120, 1),
          'soft': const Color.fromRGBO(89, 193, 120, .18),
          'shadow': const Color.fromRGBO(89, 193, 120, .3),
        },
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c.background, c.surfaceVariant, c.background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              const Text(
                'Planos para cada necessidade',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Escolha o plano ideal para você ou sua clínica. Cancele quando quiser.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onSurface.withValues(alpha: .6),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (_, box) {
                  final width = box.maxWidth;
                  final spacing = 24.0;
                  final crossAxisCount =
                      width >= 1100 ? 3 : width >= 720 ? 2 : 1;
                  final itemWidth = crossAxisCount == 1
                      ? width
                      : (width - spacing * (crossAxisCount - 1)) /
                          crossAxisCount;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: 24,
                    children: List.generate(plans.length, (index) {
                      final plan = plans[index];
                      final highlighted = plan['highlighted'] as bool;
                      final double lift =
                          highlighted && crossAxisCount > 1 ? 12 : 0;

                      return SizedBox(
                        width: itemWidth,
                        child: Transform.translate(
                          offset: Offset(0, -lift),
                          child: _PricingCard(
                            plan: plan,
                            colorScheme: c,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'Todos os planos incluem 14 dias de teste grátis. Sem cartão de crédito necessário.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onSurface.withValues(alpha: .6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final ColorScheme colorScheme;

  const _PricingCard({
    required this.plan,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final tone = plan['tone'] as Map<String, Color>;
    final highlighted = plan['highlighted'] as bool;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: highlighted ? Colors.transparent : colorScheme.outlineVariant,
        ),
        gradient: highlighted
            ? LinearGradient(
                colors: [colorScheme.surface, colorScheme.surfaceVariant],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: [
          if (highlighted)
            BoxShadow(
              color: tone['shadow']!,
              blurRadius: 60,
              spreadRadius: 4,
              offset: const Offset(0, 20),
            ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (plan.containsKey('badge'))
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: tone['soft'],
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: tone['base'],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            plan['badge'] as String,
                            style: TextStyle(
                              color: tone['base'],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  plan['name'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan['description'] as String,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: .6),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan['price'] as String,
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: tone['base'],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      plan['period'] as String,
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: highlighted
                        ? LinearGradient(
                            colors: [
                              tone['base']!,
                              tone['base']!.withValues(alpha: .8),
                            ],
                          )
                        : null,
                    border: highlighted ? null : Border.all(color: tone['soft']!),
                    boxShadow: highlighted
                        ? [
                            BoxShadow(
                              color: tone['shadow']!,
                              blurRadius: 36,
                              offset: const Offset(0, 12),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'Começar agora',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: highlighted ? Colors.white : tone['base'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                ...List.generate(
                  (plan['features'] as List).length,
                  (index) {
                    final feature = (plan['features'] as List)[index] as String;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              color: tone['soft'],
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: tone['base'],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: colorScheme.onSurface.withValues(
                                  alpha: .7,
                                ),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: highlighted ? 1 : 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      tone['base']!,
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
