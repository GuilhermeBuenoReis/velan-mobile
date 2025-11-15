import 'package:flutter/material.dart';

class AppointmentCardSkeleton extends StatelessWidget {
  const AppointmentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Skeleton(height: 12, width: 80),
            const SizedBox(height: 8),
            _Skeleton(height: 14, width: double.infinity),
            const SizedBox(height: 6),
            _Skeleton(height: 12, width: 160),
            const SizedBox(height: 12),
            _Skeleton(height: 16, width: 60),
          ],
        ),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  final double height;
  final double width;

  const _Skeleton({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: c.onSurface.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
