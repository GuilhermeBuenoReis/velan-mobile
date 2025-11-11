import 'package:flutter/material.dart';

class HealthHabits extends StatelessWidget {
  const HealthHabits({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = [
      {
        'label': 'Sono',
        'value': '7.5h',
        'goal': '8h',
        'percentage': 94,
        'color': const Color(0xFF6B5FD1),
      },
      {
        'label': 'Passos',
        'value': '8542',
        'goal': '10.000',
        'percentage': 85,
        'color': const Color(0xFF4CA3B0),
      },
      {
        'label': 'Hidratação',
        'value': '1.8L',
        'goal': '2.5L',
        'percentage': 72,
        'color': const Color(0xFF22A2F2),
      },
      {
        'label': 'Humor',
        'value': 'Ótimo',
        'goal': '—',
        'percentage': 90,
        'color': const Color(0xFFF4A21A),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Saúde e Hábitos',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 4),
          Text('Acompanhe sua evolução diária',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: habits.map((h) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .06),
                  border: Border.all(color: Colors.white.withValues(alpha: .1)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: (h['color'] as Color).withValues(alpha: .22),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.circle,
                          size: 28, color: h['color'] as Color),
                    ),
                    const SizedBox(height: 12),
                    Text(h['label'] as String,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Meta: ${h['goal']}',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(h['value'] as String,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                        Text('${h['percentage']}%',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: (h['percentage'] as int) / 100,
                      color: h['color'] as Color,
                      backgroundColor: Colors.white.withValues(alpha: .1),
                      minHeight: 6,
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
