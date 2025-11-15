import 'package:dio/dio.dart';
import 'package:velan_mobile/Models/user.dart';
import 'package:velan_mobile/Services/http_client.dart';

class ProfileApi {
  ProfileApi({Dio? client})
      : _http = AppHttpClient.instance,
        _client = client ?? AppHttpClient.instance.dio;

  final AppHttpClient _http;
  final Dio _client;

  static const String _resourcePath = '/api/profile';

  Future<User> fetchProfile() async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.get(
      _resourcePath,
      options: Options(headers: headers),
    );
    _throwIfNotSuccess(response);
    final payload = _unwrapObject(response.data);
    return User.fromJson(payload);
  }

  Future<User> updateProfile(ProfilePayload payload) async {
    final headers = await _http.prepareSecureHeaders();
    final response = await _client.patch(
      _resourcePath,
      data: payload.toJson(),
      options: Options(headers: headers, contentType: Headers.jsonContentType),
    );
    _throwIfNotSuccess(response);
    final data = _unwrapObject(response.data);
    return User.fromJson(data);
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
}

class ProfilePayload {
  ProfilePayload({
    required this.name,
    required this.email,
    this.type,
  });

  final String name;
  final String email;
  final String? type;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'type': type,
    };
  }
}
