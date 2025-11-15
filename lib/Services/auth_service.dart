import 'package:dio/dio.dart';
import 'package:velan_mobile/Services/http_client.dart';

class AuthService {
  AuthService() : _http = AppHttpClient.instance;

  final AppHttpClient _http;
  Dio get dio => _http.dio;

  final String _defaultErrorMessage =
      'Não foi possível completar sua solicitação. Tente novamente.';

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String type,
    required String role,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final headers = await _http.prepareSecureHeaders();
      final response = await dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'type': type,
          'role': role,
          'password': password,
          'password_confirmation': confirmPassword,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );

      if (!_isSuccessStatus(response.statusCode)) {
        throw Exception(
          _extractErrorMessage(response.data, response.statusCode),
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _http.setAuthToken(null);
      final headers = await _http.prepareSecureHeaders();
      final response = await dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          responseType: ResponseType.json,
          headers: headers,
        ),
      );

      if (!_isSuccessStatus(response.statusCode)) {
        throw Exception(
          _extractErrorMessage(
            response.data,
            response.statusCode,
            explicit401Message: 'Credenciais inválidas',
          ),
        );
      }

      final token = await _issueApiToken(email: email, password: password);
      _http.setAuthToken(token);
    } on DioException catch (e) {
      _http.setAuthToken(null);
      throw Exception(_handleDioError(e));
    }
  }

  Future<String> _issueApiToken({
    required String email,
    required String password,
  }) async {
    final headers = await _http.prepareSecureHeaders();
    try {
      final response = await dio.post(
        '/sanctum/token',
        data: {
          'email': email,
          'password': password,
          'device_name': 'velan_mobile_app',
        },
        options: Options(
          responseType: ResponseType.plain,
          headers: headers,
        ),
      );

      if (!_isSuccessStatus(response.statusCode)) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      final token = response.data?.toString().trim();
      if (token == null || token.isEmpty) {
        throw const FormatException();
      }
      return token;
    } on DioException catch (error) {
      final response = error.response;
      if (response != null && response.data != null) {
        final message =
            _extractErrorMessage(response.data, response.statusCode);
        if (message.isNotEmpty) {
          throw Exception(message);
        }
      }
      throw Exception('Não foi possível gerar o token de acesso.');
    } on FormatException {
      throw Exception('Resposta inesperada ao gerar token de acesso.');
    }
  }

  String _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'Tempo de conexão esgotado. Verifique sua internet e tente novamente.';
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.badCertificate) {
      return 'Não foi possível se conectar ao servidor. Tente novamente em instantes.';
    }

    final response = error.response;
    if (response != null) {
      if (response.statusCode == 419) {
        _http.invalidateCsrf();
        return 'Sessão expirada. Tente novamente.';
      }
      return _extractErrorMessage(response.data, response.statusCode);
    }

    return _defaultErrorMessage;
  }

  String _extractErrorMessage(
    dynamic data,
    int? statusCode, {
    String? explicit401Message,
  }) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        final buffer = StringBuffer();
        for (final value in errors.values) {
          if (value is List) {
            for (final item in value) {
              if (item is String && item.trim().isNotEmpty) {
                buffer.writeln(item.trim());
              }
            }
          } else if (value is String && value.trim().isNotEmpty) {
            buffer.writeln(value.trim());
          }
        }
        final errorText = buffer.toString().trim();
        if (errorText.isNotEmpty) {
          return errorText;
        }
      }
    }

    if (data is List) {
      final joined =
          data.whereType<String>().map((e) => e.trim()).join('\n').trim();
      if (joined.isNotEmpty) {
        return joined;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      final sanitized = data
          .replaceAll(RegExp(r'<[^>]*>', multiLine: true, dotAll: true), '')
          .trim();
      if (sanitized.isNotEmpty && sanitized != 'null') {
        return sanitized;
      }
    }

    if (statusCode == 401 && explicit401Message != null) {
      return explicit401Message;
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Servidor indisponível no momento. Tente novamente em alguns instantes.';
    }

    return _defaultErrorMessage;
  }

  bool _isSuccessStatus(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 200 && statusCode < 400;
  }
}
