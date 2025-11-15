import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'event_card.dart';
import 'package:velan_mobile/utils/date_only.dart';

class DayView extends StatefulWidget {
  final DateTime currentDate;
  final List<Map<String, dynamic>> events;
  final bool isLoading;
  final Function(Map<String, dynamic>) openEventModal;

  const DayView({
    super.key,
    required this.currentDate,
    required this.events,
    required this.isLoading,
    required this.openEventModal,
  });

  @override
  State<DayView> createState() => _DayViewState();
}

class _DayViewState extends State<DayView> {
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

  bool get isToday {
    final now = DateTime.now();
    return widget.currentDate.year == now.year &&
        widget.currentDate.month == now.month &&
        widget.currentDate.day == now.day;
  }

  double? _getCurrentTimePosition(List<int> visibleHours) {
    if (!isToday || visibleHours.isEmpty) return null;

    final startHour = visibleHours.first;
    final endHour = visibleHours.last + 1;
    if (currentTime.hour < startHour || currentTime.hour >= endHour) {
      return null;
    }

    final hoursSinceStart = currentTime.hour - startHour;
    return hoursSinceStart * 80 + (currentTime.minute / 60) * 80;
  }

  List<Map<String, dynamic>> get dayEvents {
    final list = widget.events.where((event) {
      final date = _eventDate(event);
      return date.year == widget.currentDate.year &&
          date.month == widget.currentDate.month &&
          date.day == widget.currentDate.day;
    }).toList();
    list.sort((a, b) {
      final aMinutes =
          ((a['startHour'] as num? ?? 0) * 60) + (a['startMinute'] as num? ?? 0);
      final bMinutes =
          ((b['startHour'] as num? ?? 0) * 60) + (b['startMinute'] as num? ?? 0);
      return aMinutes.compareTo(bMinutes);
    });
    return list;
  }

  DateTime _eventDate(Map<String, dynamic> event) {
    final dynamic value = event["dateTime"] ?? event["date"];
    return parseDateOnly(value, fallback: widget.currentDate);
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    final dayName = DateFormat.EEEE(
      "pt_BR",
    ).format(widget.currentDate).toLowerCase();
    final dayNumber = widget.currentDate.day;

    return Container(
      color: c.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              _buildHeader(c, dayName, dayNumber),
              Expanded(child: _buildHoursGrid(c)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme c, String dayName, int number) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(
          bottom: BorderSide(color: c.outline.withValues(alpha: .3)),
        ),
      ),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 14,
              color: c.onSurface.withValues(alpha: .6),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 55,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday ? c.primary : c.surface,
            ),
            child: Text(
              "$number",
              style: TextStyle(
                fontSize: 24,
                color: isToday ? Colors.white : c.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursGrid(ColorScheme c) {
    final hours = _visibleHours();
    final currentPosition = _getCurrentTimePosition(hours);

    return Stack(
      children: [
        ListView.builder(
          itemCount: hours.length,
          itemBuilder: (_, index) {
            final hour = hours[index];

            return Container(
              height: 80,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: c.outline.withValues(alpha: .2)),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat("h a").format(DateTime(2024, 1, 1, hour)),
                          style: TextStyle(
                            fontSize: 13,
                            color: c.onSurface.withValues(alpha: .6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: c.outline.withValues(alpha: .2),
                          ),
                        ),
                      ),
                      child: Stack(
                        children: dayEvents
                            .where((e) => (e["startHour"] as num?)?.toInt() == hour)
                            .map((event) {
                              final double duration =
                                  (event["durationHours"] as num).toDouble();
                              final int startMinute = event["startMinute"];

                              final double height = duration * 80;
                              final double top = (startMinute / 60) * 80;

                              return Positioned(
                                top: top,
                                left: 12,
                                right: 12,
                                height: height - 8,
                                child: GestureDetector(
                                  onTap: () => widget.openEventModal(event),
                                  child: EventCard(
                                    event: event,
                                    onTap: () {
                                      widget.openEventModal(event);
                                    },
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (currentPosition != null)
          Positioned(
            top: currentPosition,
            left: 0,
            right: 0,
            child: Row(
              children: [
                SizedBox(
                  width: 94,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                  ),
                ),
                Expanded(child: Container(height: 2, color: Colors.red)),
              ],
            ),
          ),
        if (widget.isLoading)
          Positioned.fill(
            child: Container(
              color: c.surface.withValues(alpha: .7),
              child: const Center(
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
}

  List<int> _visibleHours() {
    if (dayEvents.isEmpty) {
      return List<int>.generate(14, (i) => i + 7);
    }

    final minHour = dayEvents
        .map((e) => (e['startHour'] as num? ?? 0).toInt())
        .reduce(math.min);
    final maxEndHour = dayEvents.map((e) {
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
