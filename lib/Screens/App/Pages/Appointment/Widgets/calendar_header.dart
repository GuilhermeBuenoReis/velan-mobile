import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final String currentView;
  final VoidCallback goPrevious;
  final VoidCallback goNext;
  final VoidCallback goToday;
  final Function(String) setView;
  final bool isLoading;

  const CalendarHeader({
    super.key,
    required this.currentDate,
    required this.currentView,
    required this.goPrevious,
    required this.goNext,
    required this.goToday,
    required this.setView,
    required this.isLoading,
  });

  String formatDateRange(DateTime date, String view) {
    final locale = 'pt_BR';

    if (view == 'day') {
      return DateFormat(
        "EEEE, d 'de' MMMM 'de' yyyy",
        locale,
      ).format(date).toString();
    }

    if (view == 'week') {
      final start = date.subtract(Duration(days: date.weekday - 1));
      final end = start.add(const Duration(days: 6));

      final startStr = DateFormat('d MMM', locale).format(start);
      final endStr = DateFormat('d MMM yyyy', locale).format(end);

      return "$startStr - $endStr";
    }

    if (view == 'month') {
      return DateFormat("MMMM 'de' yyyy", locale).format(date).toString();
    }

    if (view == 'year') {
      return DateFormat("yyyy", locale).format(date).toString();
    }

    return "";
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavigationSection(c, isCompact),
                    const SizedBox(height: 16),
                    _buildActionsSection(c, isCompact),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildNavigationSection(c, isCompact)),
                    const SizedBox(width: 24),
                    Expanded(child: _buildActionsSection(c, isCompact)),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildNavigationSection(ColorScheme c, bool isCompact) {
    final title = Text(
      formatDateRange(currentDate, currentView),
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: c.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    final navButtons = isCompact
        ? Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _navIconButton(c, Icons.chevron_left, goPrevious),
              _navIconButton(c, Icons.chevron_right, goNext),
              _todayButton(c),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _navIconButton(c, Icons.chevron_left, goPrevious),
              const SizedBox(width: 8),
              _navIconButton(c, Icons.chevron_right, goNext),
              const SizedBox(width: 12),
              _todayButton(c),
            ],
          );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.calendar_today, size: 20, color: c.primary),
              const SizedBox(width: 12),
              Expanded(child: title),
            ],
          ),
          const SizedBox(height: 12),
          navButtons,
        ],
      );
    }

    return Row(
      children: [
        Icon(Icons.calendar_today, size: 20, color: c.primary),
        const SizedBox(width: 12),
        Expanded(child: title),
        const SizedBox(width: 20),
        navButtons,
      ],
    );
  }

  Widget _buildActionsSection(ColorScheme c, bool isCompact) {
    final loadingIndicator = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: c.primary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "Atualizando...",
          style: TextStyle(
            fontSize: 12,
            color: c.onSurface.withValues(alpha: .6),
          ),
        ),
      ],
    );

    final tabs = _CalendarTabs(currentView: currentView, setView: setView);
    final searchField = TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          size: 18,
          color: c.onSurface.withValues(alpha: .6),
        ),
        hintText: "Pesquisar por eventos",
        filled: true,
        fillColor: c.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: c.outline.withValues(alpha: .3),
          ),
        ),
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isLoading) ...[
            loadingIndicator,
            const SizedBox(height: 12),
          ],
          tabs,
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: searchField),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isLoading) ...[
          loadingIndicator,
          const SizedBox(width: 16),
        ],
        tabs,
        const SizedBox(width: 16),
        SizedBox(width: 230, child: searchField),
      ],
    );
  }

  IconButton _navIconButton(
    ColorScheme c,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: c.onSurface.withValues(alpha: .7),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          c.surface.withValues(alpha: .06),
        ),
      ),
    );
  }

  FilledButton _todayButton(ColorScheme c) {
    return FilledButton.tonal(
      onPressed: goToday,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        backgroundColor: c.surface.withValues(alpha: .1),
      ),
      child: Text("Hoje", style: TextStyle(color: c.onSurface)),
    );
  }
}

class _CalendarTabs extends StatelessWidget {
  final String currentView;
  final Function(String) setView;

  const _CalendarTabs({required this.currentView, required this.setView});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: c.surface.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _TabButton(
            label: "Dia",
            value: "day",
            current: currentView,
            onTap: setView,
          ),
          _TabButton(
            label: "Semana",
            value: "week",
            current: currentView,
            onTap: setView,
          ),
          _TabButton(
            label: "Mês",
            value: "month",
            current: currentView,
            onTap: setView,
          ),
          _TabButton(
            label: "Ano",
            value: "year",
            current: currentView,
            onTap: setView,
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final Function(String) onTap;

  const _TabButton({
    required this.label,
    required this.value,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final bool active = value == current;

    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: active ? c.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: c.onSurface.withValues(alpha: active ? 1 : .7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
