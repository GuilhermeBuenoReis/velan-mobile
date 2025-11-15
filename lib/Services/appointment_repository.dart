import 'package:velan_mobile/Models/appointment_model.dart';
import 'package:velan_mobile/Services/appointment_api.dart';

class AppointmentRepository {
  AppointmentRepository({AppointmentApi? api}) : _api = api ?? AppointmentApi();

  final AppointmentApi _api;

  Future<List<Appointment>> list({
    required int userId,
    required String view,
    int? year,
    int? month,
    int? week,
    String? day,
  }) {
    return _api.fetchAppointments(
      userId: userId,
      view: view,
      year: year,
      month: month,
      week: week,
      day: day,
    );
  }

  Future<Appointment> create(AppointmentPayload payload) {
    return _api.create(payload);
  }

  Future<Appointment> update(String id, AppointmentPayload payload) {
    return _api.update(id, payload);
  }

  Future<void> delete(String id) {
    return _api.delete(id);
  }
}
