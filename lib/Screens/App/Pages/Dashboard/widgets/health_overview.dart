import 'package:flutter/material.dart';

class HealthOverview extends StatelessWidget {
  const HealthOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _OverviewCard(
              label: 'Próxima Consulta',
              value: '22 Out',
              detail: 'Dr. Silva - Cardiologia',
              icon: Icons.calendar_today,
              color: const Color(0xFF6B5FD1),
            ),
            _OverviewCard(
              label: 'Último Exame',
              value: '5 dias atrás',
              detail: 'Exame de sangue',
              icon: Icons.article_outlined,
              color: const Color(0xFF4CA3B0),
            ),
            _OverviewCard(
              label: 'Médicos Ativos',
              value: '4',
              detail: 'Em acompanhamento',
              icon: Icons.people_alt,
              color: const Color(0xFFF4A21A),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _ScoreCard(),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String label;
  final String value;
  final String detail;
  final IconData icon;
  final Color color;

  const _OverviewCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
                Text(detail, style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B5FD1).withValues(alpha: .18),
            const Color(0xFF4CA3B0).withValues(alpha: .12),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Score de Saúde', style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('Baseado em seus hábitos e consultas', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: const [
                    _Progress(label: 'Atividade Física', value: 90),
                    SizedBox(height: 12),
                    _Progress(label: 'Nutrição', value: 75),
                    SizedBox(height: 12),
                    _Progress(label: 'Sono', value: 88),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      strokeWidth: 8,
                      color: const Color(0xFF6B5FD1),
                      backgroundColor: Colors.white.withValues(alpha: .1),
                    ),
                  ),
                  const Text('85', style: TextStyle(color: Colors.white, fontSize: 22)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Progress extends StatelessWidget {
  final String label;
  final int value;

  const _Progress({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text('$value%', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / 100,
          minHeight: 6,
          backgroundColor: Colors.white.withValues(alpha: .08),
          color: const Color(0xFF6B5FD1),
        ),
      ],
    );
  }
}
