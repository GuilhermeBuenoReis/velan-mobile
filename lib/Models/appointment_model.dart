class Appointment {
  Appointment({
    required this.id,
    required this.userId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.eventType,
    required this.location,
    required this.doctor,
    required this.notes,
  });

  final String id;
  final int userId;
  final String title;
  final String date;
  final String startTime;
  final int duration;
  final String eventType;
  final String location;
  final String doctor;
  final String notes;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    String _string(dynamic value, {String fallback = ''}) {
      if (value == null) return fallback;
      final text = value.toString().trim();
      if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
      return text;
    }

    int _int(dynamic value, {int fallback = 0}) {
      if (value == null) return fallback;
      if (value is num) return value.toInt();
      return int.tryParse(value.toString()) ?? fallback;
    }

    final today = DateTime.now().toIso8601String().split('T').first;
    final normalizedDuration = () {
      final value = _int(json['duration'], fallback: 60);
      return value > 0 ? value : 60;
    }();

    return Appointment(
      id: _string(json['id']),
      userId: _int(json['user_id']),
      title: _string(json['title'], fallback: 'Consulta'),
      date: _string(json['date'], fallback: today),
      startTime: _string(json['start_time'], fallback: '09:00'),
      duration: normalizedDuration,
      eventType: _string(json['event_type'], fallback: 'blue'),
      location: _string(json['location']),
      doctor: _string(json['doctor']),
      notes: _string(json['notes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'date': date,
      'start_time': startTime,
      'duration': duration > 0 ? duration : 60,
      'event_type': eventType,
      'location': location,
      'doctor': doctor,
      'notes': notes,
    };
  }
}

class AppointmentPayload {
  AppointmentPayload({
    required this.userId,
    required this.title,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.eventType,
    required this.location,
    required this.doctor,
    required this.notes,
  });

  final int userId;
  final String title;
  final String date;
  final String startTime;
  final int duration;
  final String eventType;
  final String location;
  final String doctor;
  final String notes;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'title': title,
      'date': date,
      'start_time': startTime,
      'duration': duration,
      'event_type': eventType,
      'location': location,
      'doctor': doctor,
      'notes': notes,
    };
  }
}
