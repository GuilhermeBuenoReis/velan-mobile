import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event_list_sheet.dart';
import 'package:velan_mobile/utils/date_only.dart';

class MonthView extends StatelessWidget {
  final DateTime currentDate;
  final List<Map<String, dynamic>> events;
  final Function(Map<String, dynamic>) openEventModal;
  final Function(DateTime) setDate;

  const MonthView({
    super.key,
    required this.currentDate,
    required this.events,
    required this.openEventModal,
    required this.setDate,
  });

  Color _eventColor(String color) {
    switch (color) {
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

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime? _eventDate(Map<String, dynamic> event) {
    final dynamic value = event['dateTime'] ?? event['date'];
    if (value == null) return null;
    return parseDateOnly(value);
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final referenceMonth = DateTime(currentDate.year, currentDate.month, 1);

    final eventsByDay = <DateTime, List<Map<String, dynamic>>>{};

    for (final event in events) {
      final date = _eventDate(event);
      if (date == null) continue;
      final normalized = _normalize(date);
      eventsByDay.putIfAbsent(normalized, () => []).add(event);
    }

    List<Map<String, dynamic>> eventsFor(DateTime date) {
      return eventsByDay[_normalize(date)] ?? [];
    }

    Widget buildDayCell(
      DateTime day, {
      required bool isCurrentMonth,
      required bool isToday,
      required bool isSelected,
    }) {
      final dayEvents = eventsFor(day);
      final highlightColor = isToday
          ? c.primary
          : (isSelected
                ? c.primary.withValues(alpha: .18)
                : Colors.transparent);
      final textColor = isToday
          ? Colors.white
          : (isSelected ? c.primary : c.onSurface);

      return GestureDetector(
        onTap: () {
          setDate(day);
          if (dayEvents.isNotEmpty) {
            showEventListSheet(
              context: context,
              day: day,
              events: dayEvents,
              onTapEvent: openEventModal,
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCurrentMonth
                ? c.surface
                : c.surfaceContainerHighest.withValues(alpha: .35),
            border: Border.all(color: c.outline.withValues(alpha: .08)),
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: highlightColor,
                ),
                child: Text(
                  '${day.day}',
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 26,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    spacing: 3,
                    runSpacing: 3,
                    children: [
                      ...dayEvents.take(3).map((event) {
                        return GestureDetector(
                          onTap: () => openEventModal(event),
                          child: Container(
                            width: 22,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _eventColor(event['color'] ?? 'blue'),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                      if (dayEvents.length > 3)
                        GestureDetector(
                          onTap: () => showEventListSheet(
                            context: context,
                            day: day,
                            events: dayEvents,
                            onTapEvent: openEventModal,
                          ),
                          child: Text(
                            '+${dayEvents.length - 3}',
                            style: TextStyle(
                              fontSize: 11,
                              color: c.onSurface.withValues(alpha: .6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = (constraints.maxWidth - 48).clamp(0.0, 1100.0);

        return Container(
          color: c.surface,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: TableCalendar<Map<String, dynamic>>(
                  locale: 'pt_BR',
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: currentDate,
                  currentDay: today,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'month',
                  },
                  headerVisible: false,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  availableGestures: AvailableGestures.none,
                  rowHeight: 86,
                  daysOfWeekHeight: 44,
                  eventLoader: eventsFor,
                  selectedDayPredicate: (day) => isSameDay(day, currentDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setDate(selectedDay);
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: c.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: c.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: true,
                    cellMargin: EdgeInsets.zero,
                    cellPadding: EdgeInsets.zero,
                    tablePadding: EdgeInsets.zero,
                    canMarkersOverflow: false,
                  ),
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      const labels = [
                        'Dom',
                        'Seg',
                        'Ter',
                        'Qua',
                        'Qui',
                        'Sex',
                        'Sab',
                      ];
                      return Container(
                        decoration: BoxDecoration(
                          color: c.surfaceContainerHighest.withValues(
                            alpha: .4,
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: c.outline.withValues(alpha: .08),
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          labels[day.weekday % 7],
                          style: TextStyle(
                            color: c.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) => buildDayCell(
                      day,
                      isCurrentMonth: day.month == referenceMonth.month,
                      isToday:
                          day.year == today.year &&
                          day.month == today.month &&
                          day.day == today.day,
                      isSelected: isSameDay(day, currentDate),
                    ),
                    outsideBuilder: (context, day, focusedDay) => buildDayCell(
                      day,
                      isCurrentMonth: false,
                      isToday: false,
                      isSelected: isSameDay(day, currentDate),
                    ),
                    todayBuilder: (context, day, focusedDay) => buildDayCell(
                      day,
                      isCurrentMonth: day.month == referenceMonth.month,
                      isToday: true,
                      isSelected: isSameDay(day, currentDate),
                    ),
                    selectedBuilder: (context, day, focusedDay) => buildDayCell(
                      day,
                      isCurrentMonth: day.month == referenceMonth.month,
                      isToday:
                          day.year == today.year &&
                          day.month == today.month &&
                          day.day == today.day,
                      isSelected: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
