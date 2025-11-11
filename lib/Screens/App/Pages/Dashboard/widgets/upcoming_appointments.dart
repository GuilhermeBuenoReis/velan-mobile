import 'package:flutter/material.dart';

class UpcomingAppointments extends StatelessWidget {
  const UpcomingAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final appointments = [
      {
        'doctor': 'Dr. Carlos Silva',
        'specialty': 'Cardiologia',
        'date': '22 Out 2025',
        'time': '14:30',
        'type': 'Presencial',
        'location': 'Consultório Centro',
        'status': 'Confirmada',
        'avatar':
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=100&h=100&fit=crop',
      },
      {
        'doctor': 'Dra. Ana Beatriz',
        'specialty': 'Endocrinologia',
        'date': '28 Out 2025',
        'time': '10:00',
        'type': 'Telemedicina',
        'location': 'Online',
        'status': 'Confirmada',
        'avatar':
            'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=100&h=100&fit=crop',
      },
      {
        'doctor': 'Dr. Pedro Henrique',
        'specialty': 'Ortopedia',
        'date': '02 Nov 2025',
        'time': '16:00',
        'type': 'Presencial',
        'location': 'Hospital São Lucas',
        'status': 'Pendente',
        'avatar':
            'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=100&h=100&fit=crop',
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
          const Text('Próximas Consultas',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 8),
          Text('Suas consultas agendadas',
              style: TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 16),
          Column(
            children: appointments.map((a) {
              final statusColor = a['status'] == 'Confirmada'
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF4A21A);

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: .1)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(a['avatar']!),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  a['doctor']!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: statusColor.withValues(alpha: .15),
                                  border: Border.all(
                                      color: statusColor.withValues(alpha: .35)),
                                ),
                                child: Text(
                                  a['status']!,
                                  style:
                                      TextStyle(color: statusColor, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(a['specialty']!,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 16, color: Colors.white54),
                                  const SizedBox(width: 4),
                                  Text(a['date']!,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16, color: Colors.white54),
                                  const SizedBox(width: 4),
                                  Text(a['time']!,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                      a['type'] == 'Telemedicina'
                                          ? Icons.videocam
                                          : Icons.location_on,
                                      size: 16,
                                      color: Colors.white54),
                                  const SizedBox(width: 4),
                                  Text(a['location']!,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
