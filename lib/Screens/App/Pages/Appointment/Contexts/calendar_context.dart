import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velan_mobile/Models/appointment_model.dart';
import 'package:velan_mobile/Services/appointment_repository.dart';
import 'package:velan_mobile/utils/date_only.dart';

class CalendarController extends ChangeNotifier {
  CalendarController({int initialUserId = 1})
      : _userId = initialUserId,
        _repository = AppointmentRepository() {
    fetchAppointments();
  }

  final AppointmentRepository _repository;
  final int _userId;
  int get userId => _userId;

  DateTime currentDate = DateTime.now();
  String currentView = 'month';

  List<Map<String, dynamic>> events = [];
  bool isLoading = false;

  Map<String, dynamic>? selectedEvent;
  bool isEventDetailsOpen = false;
  Map<String, dynamic>? editingEvent;

  bool isCreateModalOpen = false;
  String? draftEventDate;

  Future<void> fetchAppointments() async {
    isLoading = true;
    notifyListeners();

    try {
      final appointments = await _repository.list(
        userId: _userId,
        view: currentView,
        year: _needsYear ? currentDate.year : null,
        month: currentView == 'month' ? currentDate.month : null,
        week: currentView == 'week' ? _weekOfYear(currentDate) : null,
        day: currentView == 'day'
            ? DateFormat('yyyy-MM-dd').format(currentDate)
            : null,
      );

      events = appointments
          .map<Map<String, dynamic>?>((appointment) {
            try {
              return _mapEvent(appointment);
            } catch (_) {
              return null;
            }
          })
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (_) {
      events = [];
    }

    isLoading = false;
    notifyListeners();
  }

  bool get _needsYear => currentView != 'day';

  DateTime _parseDateOnly(String raw) =>
      parseDateOnly(raw, fallback: DateTime.now());

  DateTime _resolveStartDateTime(Appointment appointment, DateTime dateOnly) {
    final isoDate = DateFormat('yyyy-MM-dd').format(dateOnly);
    final rawValue = appointment.startTime.trim();
    final normalizedStart = rawValue.isEmpty ? '09:00' : rawValue;
    final candidates = <String>[
      normalizedStart.contains('T') ? normalizedStart : '${isoDate}T$normalizedStart',
      '$isoDate $normalizedStart',
      normalizedStart,
    ];

    for (final raw in candidates) {
      try {
        final parsed = DateTime.parse(raw);
        return DateTime(
          dateOnly.year,
          dateOnly.month,
          dateOnly.day,
          parsed.hour,
          parsed.minute,
        );
      } catch (_) {
        continue;
      }
    }

    final match = RegExp(r'(\d{1,2})[:hH](\d{2})').firstMatch(normalizedStart);
    if (match != null) {
      final hour = int.tryParse(match.group(1) ?? '') ?? 9;
      final minute = int.tryParse(match.group(2) ?? '') ?? 0;
      return DateTime(
        dateOnly.year,
        dateOnly.month,
        dateOnly.day,
        _clamp(hour, 0, 23),
        _clamp(minute, 0, 59),
      );
    }

    return DateTime(dateOnly.year, dateOnly.month, dateOnly.day, 9);
  }

  int _clamp(int value, int minValue, int maxValue) {
    if (value < minValue) return minValue;
    if (value > maxValue) return maxValue;
    return value;
  }

  Map<String, dynamic> _mapEvent(Appointment appointment) {
    final dateOnly = _parseDateOnly(appointment.date);
    final dateString = DateFormat('yyyy-MM-dd').format(dateOnly);
    final startDateTime = _resolveStartDateTime(appointment, dateOnly);
    final durationMinutes = appointment.duration > 0 ? appointment.duration : 60;
    final endDateTime =
        startDateTime.add(Duration(minutes: durationMinutes));
    return {
      'id': appointment.id,
      'title': appointment.title,
      'date': dateString,
      'dateTime': dateOnly,
      'start_time': DateFormat('HH:mm').format(startDateTime),
      'durationMinutes': durationMinutes,
      'time':
          "${DateFormat('HH:mm').format(startDateTime)} - ${DateFormat('HH:mm').format(endDateTime)}",
      'startHour': startDateTime.hour,
      'startMinute': startDateTime.minute,
      'durationHours': durationMinutes / 60,
      'color': appointment.eventType,
      'event_type': appointment.eventType,
      'location': appointment.location,
      'doctor': appointment.doctor,
      'notes': appointment.notes,
    };
  }

  int _weekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday % 7;
    final firstWeekStart = firstDayOfYear.subtract(Duration(days: daysOffset));
    return ((date.difference(firstWeekStart).inDays) / 7).floor() + 1;
  }

  void setView(String value) {
    if (currentView == value) return;
    currentView = value;
    fetchAppointments();
  }

  void setDate(DateTime value) {
    if (value.year == currentDate.year &&
        value.month == currentDate.month &&
        value.day == currentDate.day) {
      return;
    }
    currentDate = value;
    fetchAppointments();
  }

  void goNext() {
    switch (currentView) {
      case 'day':
        currentDate = currentDate.add(const Duration(days: 1));
        break;
      case 'week':
        currentDate = currentDate.add(const Duration(days: 7));
        break;
      case 'month':
        currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
        break;
      case 'year':
        currentDate = DateTime(currentDate.year + 1, 1, 1);
        break;
    }
    fetchAppointments();
  }

  void goPrevious() {
    switch (currentView) {
      case 'day':
        currentDate = currentDate.subtract(const Duration(days: 1));
        break;
      case 'week':
        currentDate = currentDate.subtract(const Duration(days: 7));
        break;
      case 'month':
        currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
        break;
      case 'year':
        currentDate = DateTime(currentDate.year - 1, 1, 1);
        break;
    }
    fetchAppointments();
  }

  void goToday() {
    currentDate = DateTime.now();
    fetchAppointments();
  }

  void openEventDetails(Map<String, dynamic> event) {
    selectedEvent = event;
    isEventDetailsOpen = true;
    notifyListeners();
  }

  void closeEventDetails() {
    selectedEvent = null;
    isEventDetailsOpen = false;
    notifyListeners();
  }

  void openCreateModal({String? date}) {
    editingEvent = null;
    draftEventDate = date ?? DateFormat('yyyy-MM-dd').format(currentDate);
    isCreateModalOpen = true;
    notifyListeners();
  }

  void openEditModal(Map<String, dynamic> event) {
    editingEvent = event;
    draftEventDate = event['date'] as String?;
    isCreateModalOpen = true;
    isEventDetailsOpen = false;
    selectedEvent = null;
    notifyListeners();
  }

  void closeCreateModal() {
    draftEventDate = null;
    editingEvent = null;
    isCreateModalOpen = false;
    notifyListeners();
  }

  Future<void> submitAppointment(Map<String, dynamic> body) async {
    if (editingEvent != null) {
      final id = editingEvent!['id']?.toString();
      if (id != null) {
        await updateAppointment(id, body);
      }
      editingEvent = null;
    } else {
      await createAppointment(body);
      editingEvent = null;
    }
  }

  Future<void> createAppointment(Map<String, dynamic> body) async {
    final payload = _payloadFromMap(body);
    await _repository.create(payload);
    await fetchAppointments();
  }

  Future<void> updateAppointment(String id, Map<String, dynamic> body) async {
    final payload = _payloadFromMap(body);
    await _repository.update(id, payload);
    await fetchAppointments();
  }

  Future<void> deleteAppointment(String id) async {
    await _repository.delete(id);
    await fetchAppointments();
  }

  Future<void> deleteEvent(Map<String, dynamic> event) async {
    final id = event['id']?.toString();
    if (id == null) return;
    await deleteAppointment(id);
    closeEventDetails();
  }

  AppointmentPayload _payloadFromMap(Map<String, dynamic> body) {
    return AppointmentPayload(
      userId: (body['user_id'] as int?) ?? _userId,
      title: body['title'] as String? ?? '',
      date: body['date'] as String? ?? DateFormat('yyyy-MM-dd').format(currentDate),
      startTime: body['start_time'] as String? ?? '09:00',
      duration: int.tryParse(body['duration'].toString()) ?? 60,
      eventType: body['event_type'] as String? ?? 'blue',
      location: body['location'] as String? ?? '',
      doctor: body['doctor'] as String? ?? '',
      notes: body['notes'] as String? ?? '',
    );
  }
}
