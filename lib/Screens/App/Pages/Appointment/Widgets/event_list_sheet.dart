import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> showEventListSheet({
  required BuildContext context,
  required DateTime day,
  required List<Map<String, dynamic>> events,
  required void Function(Map<String, dynamic>) onTapEvent,
}) async {
  if (events.isEmpty) return;

  final sorted = [...events]
    ..sort((a, b) {
      final aMinutes =
          ((a['startHour'] as num? ?? 0) * 60) + (a['startMinute'] as num? ?? 0);
      final bMinutes =
          ((b['startHour'] as num? ?? 0) * 60) + (b['startMinute'] as num? ?? 0);
      return aMinutes.compareTo(bMinutes);
    });

  final dateLabel = DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(day);

  await showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              ...sorted.map(
                (event) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 6,
                    backgroundColor: _eventColor(event['color']),
                  ),
                  title: Text(event['title'] ?? 'Consulta'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['time'] ?? ''),
                      if ((event['location'] as String?)?.isNotEmpty ?? false)
                        Text(
                          event['location'],
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onTapEvent(event);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Color _eventColor(String? key) {
  switch (key) {
    case 'purple':
      return Colors.purple;
    case 'orange':
      return Colors.orange;
    case 'red':
      return Colors.red;
    default:
      return Colors.blue;
  }
}
