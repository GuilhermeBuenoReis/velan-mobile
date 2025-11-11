import 'package:flutter/material.dart';

class MessagesPanel extends StatelessWidget {
  const MessagesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {
        'sender': 'Dr. Carlos Silva',
        'message': 'Olá Guilherme! Seus últimos exames estão ótimos.',
        'time': '10:30',
        'avatar':
            'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=100&h=100&fit=crop',
        'unread': true,
      },
      {
        'sender': 'Dra. Ana Beatriz',
        'message':
            'Não esqueça de trazer seus exames anteriores na próxima consulta.',
        'time': 'Ontem',
        'avatar':
            'https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=100&h=100&fit=crop',
        'unread': false,
      },
      {
        'sender': 'Velan Saúde',
        'message': 'Sua consulta foi confirmada para amanhã às 14:30.',
        'time': '2 dias',
        'avatar': '',
        'unread': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Column(
        children: [
          const Text(
            'Mensagens',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            'Converse com seus médicos',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final m = messages[i];

                final String sender = m['sender'] as String;
                final String time = m['time'] as String;
                final String message = m['message'] as String;
                final String avatar = m['avatar'] as String;
                final bool unread = m['unread'] as bool;

                final Color accent = const Color(0xFF6B5FD1);

                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: unread
                        ? accent.withValues(alpha: .08)
                        : Colors.white.withValues(alpha: .04),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: unread
                          ? accent.withValues(alpha: .25)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            avatar.isNotEmpty ? NetworkImage(avatar) : null,
                        child: avatar.isEmpty
                            ? const Text('V',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16))
                            : const SizedBox(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    sender,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                Text(
                                  time,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 13),
                            ),
                            if (unread)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  color: accent,
                                  shape: BoxShape.circle,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Digite sua mensagem',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: .06),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.white.withValues(alpha: .1)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B5FD1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
