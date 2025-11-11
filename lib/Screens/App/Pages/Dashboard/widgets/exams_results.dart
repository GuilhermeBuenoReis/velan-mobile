import 'package:flutter/material.dart';
import 'exams_pagination.dart';

class ExamsResults extends StatefulWidget {
  const ExamsResults({super.key});

  @override
  State<ExamsResults> createState() => _ExamsResultsState();
}

class _ExamsResultsState extends State<ExamsResults> {
  String activeTab = 'recent';
  int currentPage = 1;

  List<Map<String, dynamic>> get recent => [
        {
          'name': 'Hemograma Completo',
          'date': '15 Out 2025',
          'doctor': 'Dr. Carlos Silva',
          'highlight': true,
        },
        {
          'name': 'Glicemia em Jejum',
          'date': '10 Out 2025',
          'doctor': 'Dra. Ana Beatriz',
          'highlight': false,
        },
        {
          'name': 'Radiografia de Tórax',
          'date': '05 Out 2025',
          'doctor': 'Dr. Pedro Henrique',
          'highlight': false,
        },
        {
          'name': 'Ressonância Magnética',
          'date': '28 Set 2025',
          'doctor': 'Dra. Sofia Mendes',
          'highlight': false,
        },
      ];

  List<Map<String, dynamic>> get history => [
        {
          'name': 'Eletrocardiograma',
          'date': '20 Set 2025',
          'doctor': 'Dr. Carlos Silva',
        },
        {
          'name': 'Ultrassom Abdominal',
          'date': '15 Ago 2025',
          'doctor': 'Dra. Ana Beatriz',
        },
        {
          'name': 'Ressonância de Joelho',
          'date': '02 Jul 2025',
          'doctor': 'Dr. Gustavo Souza',
        },
        {
          'name': 'Mapeamento de Retina',
          'date': '18 Jun 2025',
          'doctor': 'Dra. Lívia Campos',
        },
        {
          'name': 'Exame de Colesterol',
          'date': '30 Mai 2025',
          'doctor': 'Dr. Ricardo Lima',
        },
      ];

  List<Map<String, dynamic>> get currentList =>
      activeTab == 'recent' ? recent : history;

  @override
  Widget build(BuildContext context) {
    final paginated = currentList.skip((currentPage - 1) * 3).take(3).toList();
    final totalPages = (currentList.length / 3).ceil();

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
          const Text('Resultados e Exames',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text('Acesse seus resultados médicos',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 20),
          Row(
            children: [
              _TabButton(
                label: 'Recentes',
                active: activeTab == 'recent',
                onTap: () {
                  setState(() {
                    activeTab = 'recent';
                    currentPage = 1;
                  });
                },
              ),
              _TabButton(
                label: 'Histórico',
                active: activeTab == 'history',
                onTap: () {
                  setState(() {
                    activeTab = 'history';
                    currentPage = 1;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: paginated.map((exam) {
              final accent = exam['highlight'] == true
                  ? const Color(0xFFF4A21A)
                  : const Color(0xFF6B5FD1);

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: accent.withValues(alpha: .3)),
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.description,
                          size: 28, color: accent.withValues(alpha: .9)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(exam['name'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 14, color: Colors.white54),
                              const SizedBox(width: 4),
                              Text(exam['date'],
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              const SizedBox(width: 8),
                              Text(exam['doctor'],
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          ExamsPagination(
            currentPage: currentPage,
            totalPages: totalPages,
            onPageChange: (p) {
              setState(() => currentPage = p);
            },
          )
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: active
                    ? const Color(0xFF6B5FD1)
                    : Colors.white.withValues(alpha: .08),
              ),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.white70,
              fontSize: active ? 15 : 14,
            ),
          ),
        ),
      ),
    );
  }
}
