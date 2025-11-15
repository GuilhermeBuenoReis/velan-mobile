import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  LinearGradient _gradientForColor(ColorScheme c, String color) {
    switch (color) {
      case 'blue':
        return LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: .9),
            Colors.blue.shade700.withValues(alpha: .9),
          ],
        );
      case 'purple':
        return LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: .9),
            Colors.purple.shade700.withValues(alpha: .9),
          ],
        );
      case 'orange':
        return LinearGradient(
          colors: [
            Colors.orange.withValues(alpha: .9),
            Colors.deepOrange.withValues(alpha: .9),
          ],
        );
      case 'red':
        return LinearGradient(
          colors: [
            Colors.red.withValues(alpha: .9),
            Colors.red.shade700.withValues(alpha: .9),
          ],
        );
      default:
        return LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: .9),
            Colors.blue.shade700.withValues(alpha: .9),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final gradient = _gradientForColor(c, event["color"] ?? "blue");

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                event["time"] ?? "",
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              event["title"] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.1,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (event["location"] != null &&
                (event["location"] as String).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  "📍 ${event["location"]}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
