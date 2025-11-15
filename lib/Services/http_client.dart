import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class AppHttpClient {
  AppHttpClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: const {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    dio.interceptors.add(CookieManager(_cookieJar));
  }

  static final AppHttpClient instance = AppHttpClient._internal();

  static const String _baseUrl = 'http://10.0.2.2:8000';

  late final Dio dio;
  final CookieJar _cookieJar = CookieJar();
  bool _csrfInitialized = false;
  String? _authToken;

  String? get authToken => _authToken;

  Future<Map<String, String>> prepareSecureHeaders() async {
    await _ensureCsrfToken();
    var token = await _readXsrfToken();
    if (token == null) {
      _csrfInitialized = false;
      await _ensureCsrfToken();
      token = await _readXsrfToken();
      if (token == null) return _buildAuthHeaders();
    }
    return {
      ..._buildAuthHeaders(),
      'X-XSRF-TOKEN': token,
    };
  }

  Future<void> _ensureCsrfToken() async {
    if (_csrfInitialized) return;
    await dio.get('/sanctum/csrf-cookie');
    _csrfInitialized = true;
  }

  Future<String?> _readXsrfToken() async {
    final uri = Uri.parse(_baseUrl);
    final cookies = await _cookieJar.loadForRequest(uri);
    for (final cookie in cookies) {
      if (cookie.name == 'XSRF-TOKEN' && cookie.value.isNotEmpty) {
        return Uri.decodeComponent(cookie.value);
      }
    }
    return null;
  }

  void invalidateCsrf() {
    _csrfInitialized = false;
  }

  void setAuthToken(String? token) {
    _authToken = token;
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
      return;
    }
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Map<String, String> _buildAuthHeaders() {
    if (_authToken == null || _authToken!.isEmpty) return const {};
    return {'Authorization': 'Bearer $_authToken'};
  }
}
