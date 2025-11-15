import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_list_sheet.dart';
import 'package:velan_mobile/utils/date_only.dart';

class YearView extends StatelessWidget {
  final DateTime currentDate;
  final List<Map<String, dynamic>> events;
  final Function(DateTime) setDate;
  final VoidCallback clearSelectedEvent;
  final Function(String) setView;
  final Function(Map<String, dynamic>) openEventModal;

  const YearView({
    super.key,
    required this.currentDate,
    required this.events,
    required this.setDate,
    required this.clearSelectedEvent,
    required this.setView,
    required this.openEventModal,
  });

  static const weekDays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  List<int?> getDaysInMonth(int monthIndex, int year) {
    final firstDay = DateTime(year, monthIndex + 1, 1);
    final daysInMonth = DateTime(year, monthIndex + 2, 0).day;
    final startDayOfWeek = firstDay.weekday % 7;
    final list = <int?>[];

    for (int i = 0; i < startDayOfWeek; i++) {
      list.add(null);
    }
    for (int d = 1; d <= daysInMonth; d++) {
      list.add(d);
    }

    return list;
  }

  bool hasEventsOnDay(int monthIndex, int day, int year) {
    final date = DateTime(year, monthIndex + 1, day);
    return eventsOn(date).isNotEmpty;
  }

  bool isToday(int monthIndex, int day, int year) {
    final now = DateTime.now();
    return now.year == year && now.month == monthIndex + 1 && now.day == day;
  }

  List<Map<String, dynamic>> eventsOn(DateTime date) {
    return events.where((e) {
      final d = _eventDate(e);
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  DateTime _eventDate(Map<String, dynamic> event) {
    final dynamic value = event["dateTime"] ?? event["date"];
    return parseDateOnly(value, fallback: currentDate);
  }

  void handleMonthClick(int monthIndex, int year) {
    final selectedMonth = DateTime(year, monthIndex + 1, 1);
    setDate(selectedMonth);
    clearSelectedEvent();
    setView("month");
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final year = currentDate.year;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int crossAxisCount = 4;
        if (width < 1100) crossAxisCount = 3;
        if (width < 800) crossAxisCount = 2;

        final double aspectRatio;
        if (crossAxisCount == 2) {
          aspectRatio = 1.15;
        } else if (crossAxisCount == 3) {
          aspectRatio = 1.0;
        } else {
          aspectRatio = 0.9;
        }

        final months = List.generate(
          12,
          (i) => DateFormat.MMMM("pt_BR").format(DateTime(year, i + 1, 1)),
        );

        return Container(
          color: c.surface,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: aspectRatio,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: 12,
                  itemBuilder: (_, monthIndex) {
                    final days = getDaysInMonth(monthIndex, year);

                    return GestureDetector(
                      onTap: () => handleMonthClick(monthIndex, year),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: c.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: c.outline.withValues(alpha: .3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              months[monthIndex],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: c.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: weekDays.map((d) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: c.onSurface.withValues(alpha: .6),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                ),
                                itemCount: days.length,
                                itemBuilder: (_, i) {
                                  final day = days[i];
                                  if (day == null) {
                                    return const SizedBox.shrink();
                                  }

                                  final today = isToday(monthIndex, day, year);
                                  final hasEvents = hasEventsOnDay(
                                    monthIndex,
                                    day,
                                    year,
                                  );
                                  final date = DateTime(year, monthIndex + 1, day);
                                  final dayEvents = eventsOn(date);

                                  return GestureDetector(
                                    onTap: () {
                                      if (dayEvents.isEmpty) return;
                                      showEventListSheet(
                                        context: context,
                                        day: date,
                                        events: dayEvents,
                                        onTapEvent: openEventModal,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: today ? c.primary : c.surface,
                                        borderRadius: BorderRadius.circular(6),
                                        border: hasEvents
                                            ? Border.all(
                                                color: c.primary.withValues(
                                                  alpha: .4,
                                                ),
                                              )
                                            : null,
                                      ),
                                      alignment: Alignment.center,
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Text(
                                              "$day",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: today
                                                    ? Colors.white
                                                    : c.onSurface,
                                                fontWeight: today
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          if (hasEvents && !today)
                                            Positioned(
                                              bottom: 3,
                                              left: 0,
                                              right: 0,
                                              child: Center(
                                                child: Container(
                                                  width: 5,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                    color: c.primary,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
