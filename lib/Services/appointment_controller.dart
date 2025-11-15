import 'package:flutter/foundation.dart';
import 'package:velan_mobile/Models/appointment_model.dart';
import 'package:velan_mobile/Services/appointment_repository.dart';

class AppointmentController extends ChangeNotifier {
  AppointmentController({AppointmentRepository? repository})
      : _repository = repository ?? AppointmentRepository();

  final AppointmentRepository _repository;

  List<Appointment> appointments = [];
  bool isLoading = false;

  Future<void> loadAppointments({
    required int userId,
    required String view,
    int? year,
    int? month,
    int? week,
    String? day,
  }) async {
    isLoading = true;
    notifyListeners();
    appointments = await _repository.list(
      userId: userId,
      view: view,
      year: year,
      month: month,
      week: week,
      day: day,
    );
    isLoading = false;
    notifyListeners();
  }

  Future<Appointment> createAppointment(AppointmentPayload payload) async {
    final appointment = await _repository.create(payload);
    appointments = [...appointments, appointment];
    notifyListeners();
    return appointment;
  }

  Future<Appointment> updateAppointment(
    String id,
    AppointmentPayload payload,
  ) async {
    final updated = await _repository.update(id, payload);
    appointments = appointments
        .map(
          (item) => item.id == id ? updated : item,
        )
        .toList();
    notifyListeners();
    return updated;
  }

  Future<void> deleteAppointment(String id) async {
    await _repository.delete(id);
    appointments = appointments.where((item) => item.id != id).toList();
    notifyListeners();
  }
}
