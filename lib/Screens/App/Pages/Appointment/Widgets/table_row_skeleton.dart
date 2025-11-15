import 'package:flutter/material.dart';

class TableRowSkeleton extends StatelessWidget {
  const TableRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    Widget box(double h, double w) {
      return Container(
        height: h,
        width: w,
        decoration: BoxDecoration(
          color: c.surfaceVariant.withValues(alpha: .4),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.outline.withValues(alpha: .2)),
        ),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: box(32, 120)),
          Expanded(flex: 2, child: box(32, 120)),
          Expanded(flex: 1, child: box(16, 80)),
          Expanded(flex: 1, child: box(16, 60)),
          Expanded(flex: 1, child: box(24, 80)),
          Expanded(flex: 2, child: box(24, 100)),
          Expanded(flex: 2, child: box(32, 140)),
        ],
      ),
    );
  }
}
