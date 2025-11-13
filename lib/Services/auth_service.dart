import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class AuthService {
  AuthService() {
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8000',
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
      validateStatus: (status) => status != null && status < 500,
      headers: {
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    ),
  );
  final CookieJar _cookieJar = CookieJar();
  bool _csrfInitialized = false;

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
      final headers = await _prepareSecureHeaders();
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
        throw Exception(_extractErrorMessage(response.data, response.statusCode));
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final headers = await _prepareSecureHeaders();
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
          _extractErrorMessage(response.data, response.statusCode,
              explicit401Message: 'Credenciais inválidas'),
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
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
        _csrfInitialized = false;
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
      final joined = data.whereType<String>().map((e) => e.trim()).join('\n').trim();
      if (joined.isNotEmpty) {
        return joined;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      final sanitized =
          data.replaceAll(RegExp(r'<[^>]*>', multiLine: true, dotAll: true), '').trim();
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

  Future<Map<String, String>> _prepareSecureHeaders() async {
    await _ensureCsrfToken();
    var token = await _readXsrfToken();
    if (token == null) {
      _csrfInitialized = false;
      await _ensureCsrfToken();
      token = await _readXsrfToken();
    }
    final headers = <String, String>{};
    if (token != null) {
      headers['X-XSRF-TOKEN'] = token;
    }
    return headers;
  }

  Future<void> _ensureCsrfToken() async {
    if (_csrfInitialized) return;
    try {
      await dio.get('/sanctum/csrf-cookie');
      _csrfInitialized = true;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    }
  }

  Future<String?> _readXsrfToken() async {
    final uri = Uri.parse(dio.options.baseUrl);
    final cookies = await _cookieJar.loadForRequest(uri);
    for (final cookie in cookies) {
      if (cookie.name.toLowerCase() == 'xsrf-token') {
        return Uri.decodeComponent(cookie.value);
      }
    }
    return null;
  }

  bool _isSuccessStatus(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 200 && statusCode < 400;
  }
}
