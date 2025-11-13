import 'package:flutter/material.dart';

class WelcomeSystemDemo extends StatelessWidget {
  const WelcomeSystemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final stats = [
      {
        'label': 'Consultas hoje',
        'value': '12',
        'toneBase': const Color.fromRGBO(107, 95, 209, 1),
        'toneSoft': const Color.fromRGBO(107, 95, 209, .16),
      },
      {
        'label': 'Pacientes ativos',
        'value': '248',
        'toneBase': const Color.fromRGBO(76, 163, 176, 1),
        'toneSoft': const Color.fromRGBO(76, 163, 176, .16),
      },
      {
        'label': 'Taxa de satisfação',
        'value': '98%',
        'toneBase': const Color.fromRGBO(89, 193, 120, 1),
        'toneSoft': const Color.fromRGBO(89, 193, 120, .18),
      },
    ];

    final scheduleItems = [
      {'time': '13:00'},
      {'time': '12:00'},
      {'time': '11:00'},
    ];

    final chartData = [
      {'height': 40.0},
      {'height': 70.0},
      {'height': 50.0},
      {'height': 80.0},
      {'height': 60.0},
      {'height': 90.0},
      {'height': 75.0},
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
                'Tecnologia que funciona',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Interface intuitiva e moderna, desenhada para profissionais que valorizam eficiência',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: c.onSurface.withValues(alpha: .6),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 60),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              c.primary.withValues(alpha: .2),
                              c.secondary.withValues(alpha: .2),
                              c.tertiary.withValues(alpha: .2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: c.outlineVariant),
                        color: c.surface,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(14, 13, 19, .35),
                            blurRadius: 80,
                            spreadRadius: 4,
                            offset: const Offset(0, 30),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: c.outlineVariant.withValues(alpha: .7),
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: [c.surfaceVariant, c.surface],
                              ),
                            ),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        color: c.error.withValues(alpha: .8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        color: c.secondary.withValues(
                                          alpha: .8,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      height: 12,
                                      width: 12,
                                      decoration: BoxDecoration(
                                        color: c.tertiary.withValues(alpha: .8),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  'Dashboard - Velan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: c.onSurface.withValues(alpha: .6),
                                  ),
                                ),
                                const Spacer(),
                                const SizedBox(width: 48),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                LayoutBuilder(
                                  builder: (_, statsConstraints) {
                                    final statsWidth =
                                        statsConstraints.maxWidth;
                                    final crossAxisCount =
                                        statsWidth >= 900
                                            ? 3
                                            : statsWidth >= 600
                                                ? 2
                                                : 1;
                                    final childAspectRatio =
                                        crossAxisCount == 1
                                            ? 2.8
                                            : crossAxisCount == 2
                                                ? 2.2
                                                : 1.9;

                                    return GridView.builder(
                                      itemCount: stats.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        mainAxisSpacing: 16,
                                        crossAxisSpacing: 16,
                                        childAspectRatio: childAspectRatio,
                                      ),
                                      itemBuilder: (_, i) {
                                        final stat = stats[i];
                                        return Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: c.outlineVariant
                                                  .withValues(
                                                alpha: .6,
                                              ),
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                c.surfaceVariant.withValues(
                                                  alpha: .8,
                                                ),
                                                c.surface,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                stat['label'] as String,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      c.onSurface.withValues(
                                                    alpha: .6,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                stat['value'] as String,
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      stat['toneBase'] as Color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 32),
                                LayoutBuilder(
                                  builder: (_, constraints) {
                                    final isWide = constraints.maxWidth >= 900;

                                    Widget scheduleCard() => Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: c.outlineVariant
                                                  .withValues(alpha: .6),
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                c.surfaceVariant.withValues(
                                                  alpha: .8,
                                                ),
                                                c.surface,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Próximas consultas',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Column(
                                                children: scheduleItems
                                                    .map(
                                                      (item) => Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                          bottom: 12,
                                                        ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                          14,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                          border: Border.all(
                                                            color: c
                                                                .outlineVariant
                                                                .withValues(
                                                              alpha: .8,
                                                            ),
                                                          ),
                                                          color: c.surface,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  12,
                                                                ),
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    c.primary,
                                                                    c.primary
                                                                        .withValues(
                                                                      alpha: .7,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    height: 8,
                                                                    width: 110,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        6,
                                                                      ),
                                                                      color: c
                                                                          .onSurface
                                                                          .withValues(
                                                                            alpha:
                                                                                .1,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8,
                                                                  ),
                                                                  Container(
                                                                    height: 6,
                                                                    width: 80,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        6,
                                                                      ),
                                                                      color: c
                                                                          .onSurface
                                                                          .withValues(
                                                                            alpha:
                                                                                .1,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 16,
                                                            ),
                                                            Text(
                                                              item['time']
                                                                  as String,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    c.secondary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        );

                                    Widget chartCard() => Container(
                                          padding: const EdgeInsets.all(24),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            border: Border.all(
                                              color: c.outlineVariant
                                                  .withValues(alpha: .6),
                                            ),
                                            gradient: LinearGradient(
                                              colors: [
                                                c.surfaceVariant.withValues(
                                                  alpha: .8,
                                                ),
                                                c.surface,
                                              ],
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Visão geral',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 18),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: chartData
                                                    .map(
                                                      (bar) => Expanded(
                                                        child: AnimatedContainer(
                                                          duration:
                                                              const Duration(
                                                                milliseconds:
                                                                    600,
                                                              ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            right: 6,
                                                          ),
                                                          height:
                                                              (bar['height']
                                                                  as double) *
                                                              2,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              12,
                                                            ),
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                c.primary,
                                                                c.secondary,
                                                              ],
                                                              begin: Alignment
                                                                  .bottomCenter,
                                                              end: Alignment
                                                                  .topCenter,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ],
                                          ),
                                        );

                                    if (isWide) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(child: scheduleCard()),
                                          const SizedBox(width: 24),
                                          Expanded(child: chartCard()),
                                        ],
                                      );
                                    }

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        scheduleCard(),
                                        const SizedBox(height: 24),
                                        chartCard(),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 28),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [
                                            c.primary,
                                            c.primary.withValues(alpha: .8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: c.primary.withValues(
                                              alpha: .3,
                                            ),
                                            blurRadius: 24,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        'Nova consulta',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: c.secondary.withValues(
                                            alpha: .6,
                                          ),
                                        ),
                                        color: c.surface,
                                      ),
                                      child: Text(
                                        'Relatórios',
                                        style: TextStyle(
                                          color: c.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: c.outlineVariant.withValues(
                                            alpha: .7,
                                          ),
                                        ),
                                        color: c.surface,
                                      ),
                                      child: Text(
                                        'Configurações',
                                        style: TextStyle(
                                          color: c.onSurface,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: -40,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              c.primary.withValues(alpha: .1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
