import 'package:dio/dio.dart';
import 'package:velan_mobile/Models/appointment_model.dart';
import 'package:velan_mobile/Services/http_client.dart';

class AppointmentApi {
  AppointmentApi({Dio? client})
    : _http = AppHttpClient.instance,
      _client = client ?? AppHttpClient.instance.dio;

  final AppHttpClient _http;
  final Dio _client;

  Future<List<Appointment>> fetchAppointments({
    required int userId,
    required String view,
    int? year,
    int? month,
    int? week,
    String? day,
  }) async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.get(
      _resourcePath,
      queryParameters: {
        'user_id': userId,
        'view': view,
        if (year != null) 'year': year,
        if (month != null) 'month': month,
        if (week != null) 'week': week,
        if (day != null) 'day': day,
      },
      options: Options(headers: headers),
    );
    _throwIfNotSuccess(response);
    final data = _unwrapList(response.data);
    return data
        .map((item) => Appointment.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Appointment> create(AppointmentPayload data) async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.post(
      _resourcePath,
      data: data.toJson(),
      options: Options(contentType: Headers.jsonContentType, headers: headers),
    );
    _throwIfNotSuccess(response);
    final payload = _unwrapObject(response.data);
    return Appointment.fromJson(payload);
  }

  Future<Appointment> update(String id, AppointmentPayload data) async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.put(
      '$_resourcePath/$id',
      data: data.toJson(),
      options: Options(contentType: Headers.jsonContentType, headers: headers),
    );
    _throwIfNotSuccess(response);
    final payload = _unwrapObject(response.data);
    return Appointment.fromJson(payload);
  }

  Future<void> delete(String id) async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.delete(
      '$_resourcePath/$id',
      options: Options(headers: headers),
    );
    _throwIfNotSuccess(response);
  }

  List<dynamic> _unwrapList(dynamic data) {
    return _extractList(data) ?? const [];
  }

  List<dynamic>? _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map<String, dynamic>) {
      const preferredKeys = ['data', 'appointments', 'items', 'results'];
      for (final key in preferredKeys) {
        if (!data.containsKey(key)) continue;
        final result = _extractList(data[key]);
        if (result != null) return result;
      }
      for (final value in data.values) {
        final result = _extractList(value);
        if (result != null) return result;
      }
    }
    return null;
  }

  Map<String, dynamic> _unwrapObject(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    throw StateError('Resposta inesperada do servidor: $data');
  }

  void _throwIfNotSuccess(Response<dynamic> response) {
    final status = response.statusCode ?? 500;
    if (status < 200 || status >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: response.data,
      );
    }
  }

  static const String _resourcePath = '/api/appointments';
}
