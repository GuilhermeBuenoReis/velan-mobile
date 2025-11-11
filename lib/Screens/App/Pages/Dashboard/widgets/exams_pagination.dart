import 'package:flutter/material.dart';

class ExamsPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChange;

  const ExamsPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:
              currentPage > 1 ? () => onPageChange(currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left, color: Colors.white70),
        ),
        Row(
          children: List.generate(totalPages, (i) {
            final page = i + 1;
            final active = page == currentPage;

            return GestureDetector(
              onTap: () => onPageChange(page),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF6B5FD1)
                      : Colors.white.withValues(alpha: .05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$page",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ),
        IconButton(
          onPressed: currentPage < totalPages
              ? () => onPageChange(currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right, color: Colors.white70),
        ),
      ],
    );
  }
}
