import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velan_mobile/utils/date_only.dart';

class WeekView extends StatefulWidget {
  final DateTime currentDate;
  final List<Map<String, dynamic>> events;
  final Function(Map<String, dynamic>) openEventModal;

  const WeekView({
    super.key,
    required this.currentDate,
    required this.events,
    required this.openEventModal,
  });

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  static const DAYS = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];

  late DateTime currentTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();

    timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() => currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  List<DateTime> get weekDates {
    final startOfWeek = widget.currentDate.subtract(
      Duration(days: widget.currentDate.weekday % 7),
    );
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  List<Map<String, dynamic>> dayEvents(int dayIndex) {
    final date = weekDates[dayIndex];
    return widget.events.where((event) {
      final d = _eventDate(event);
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  double? timeIndicatorPosition(List<int> hours) {
    final now = currentTime;
    final weekStart = weekDates.first;
    final weekEnd = weekDates.last.add(const Duration(hours: 23, minutes: 59));

    if (now.isBefore(weekStart) || now.isAfter(weekEnd)) return null;
    if (hours.isEmpty) return null;
    final startHour = hours.first;
    final endHour = hours.last + 1;
    if (now.hour < startHour || now.hour >= endHour) return null;

    final hoursSinceStart = now.hour - startHour;
    return hoursSinceStart * 80 + (now.minute / 60) * 80;
  }

  int get timeIndicatorDayIndex {
    return currentTime.weekday % 7;
  }

  DateTime _eventDate(Map<String, dynamic> event) {
    final dynamic value = event["dateTime"] ?? event["date"];
    return parseDateOnly(value, fallback: widget.currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final hours = _visibleHours();
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 600;
        return Container(
          color: c.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 900,
              height: height as double,
              child: Column(
                children: [
                  _buildHeader(c),
                  Expanded(child: _buildGrid(c, hours)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme c) {
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(color: c.outline.withValues(alpha: .2)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: c.outline.withValues(alpha: .2)),
              ),
            ),
            child: Text(
              "Local Time",
              style: TextStyle(
                fontSize: 11,
                color: c.onSurface.withValues(alpha: .5),
              ),
            ),
          ),
          ...List.generate(7, (i) {
            final date = weekDates[i];
            return Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: i == 6
                          ? Colors.transparent
                          : c.outline.withValues(alpha: .2),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      DAYS[i],
                      style: TextStyle(
                        fontSize: 12,
                        color: c.onSurface.withValues(alpha: .5),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isToday(date) ? c.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          color: isToday(date) ? Colors.white : c.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGrid(ColorScheme c, List<int> hours) {
    final indicatorPos = timeIndicatorPosition(hours);
    final indicatorDay = timeIndicatorDayIndex;
    final totalHeight = (hours.length * 80).toDouble();

    return SingleChildScrollView(
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          children: [
            Column(
              children: hours.map((hour) {
                return Row(
                  children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.only(right: 12),
                      height: 80,
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: c.outline.withValues(alpha: .2),
                          ),
                          right: BorderSide(
                            color: c.outline.withValues(alpha: .2),
                          ),
                        ),
                      ),
                      child: Text(
                        DateFormat("h a").format(DateTime(2024, 1, 1, hour)),
                        style: TextStyle(
                          fontSize: 12,
                          color: c.onSurface.withValues(alpha: .6),
                        ),
                      ),
                    ),
                    ...List.generate(7, (dayIndex) {
                      final date = weekDates[dayIndex];
                      final items = dayEvents(
                        dayIndex,
                      ).where((e) => (e["startHour"] as num?)?.toInt() == hour).toList();

                      return Expanded(
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: isToday(date)
                                ? c.primary.withValues(alpha: .06)
                                : c.surface,
                            border: Border(
                              bottom: BorderSide(
                                color: c.outline.withValues(alpha: .2),
                              ),
                              right: BorderSide(
                                color: dayIndex == 6
                                    ? Colors.transparent
                                    : c.outline.withValues(alpha: .2),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: items.map((event) {
                              final height =
                                  (event["durationHours"] as num).toDouble() *
                                  80;
                              final top =
                                  (event["startMinute"] as num).toDouble() /
                                  60 *
                                  80;

                              return Positioned(
                                top: top,
                                left: 6,
                                right: 6,
                                height: height - 8,
                                child: GestureDetector(
                                  onTap: () => widget.openEventModal(event),
                                  child: _EventCard(event: event),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
            if (indicatorPos != null)
              Positioned(
                top: indicatorPos,
                left: 0,
                right: 0,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 74,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ),
                    ...List.generate(7, (i) {
                      return Expanded(
                        child: Opacity(
                          opacity: i == indicatorDay ? 1 : 0,
                          child: Container(height: 2, color: Colors.red),
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
}

  List<int> _visibleHours() {
    final allEvents = widget.events;
    if (allEvents.isEmpty) {
      return List<int>.generate(14, (i) => i + 7);
    }

    final minHour = allEvents
        .map((e) => (e['startHour'] as num? ?? 0).toInt())
        .reduce(math.min);
    final maxEndHour = allEvents.map((e) {
      final start = (e['startHour'] as num? ?? 0).toDouble();
      final duration = (e['durationHours'] as num? ?? 1).toDouble();
      return start + duration;
    }).reduce(math.max);

    final normalizedStart = math.max(0, minHour - 1);
    final normalizedEnd = math.min(24, maxEndHour.ceil() + 1);

    return List<int>.generate(
      math.max(1, normalizedEnd - normalizedStart),
      (i) => normalizedStart + i,
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final color = event["color"] ?? "blue";

    final gradient = {
      "blue": [Colors.blue.shade500, Colors.blue.shade600],
      "purple": [Colors.purple.shade500, Colors.purple.shade600],
      "orange": [Colors.orange.shade500, Colors.orange.shade600],
      "red": [Colors.red.shade500, Colors.red.shade600],
    }[color]!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(50, 0, 0, 0),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              event["time"],
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            event["title"],
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
