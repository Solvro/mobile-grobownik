import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthInterceptor extends QueuedInterceptorsWrapper {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString("access_token");

    if (accessToken != null) {
      options.headers["Authorization"] = "Bearer $accessToken";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    if (request.extra["retried"] == true) {
      handler.next(err);
      return;
    }

    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString("refresh_token");

    if (refreshToken == null) {
      await prefs.remove("access_token");
      await prefs.remove("refresh_token");
      await _retryWithoutAuth(request, handler);
      return;
    }

    final _RefreshResult? refreshResult;
    try {
      refreshResult = await _refreshToken(refreshToken, request);
    } on DioException catch (refreshError) {
      handler.next(refreshError);
      return;
    }

    if (refreshResult == null) {
      await prefs.remove("access_token");
      await prefs.remove("refresh_token");
      await _retryWithoutAuth(request, handler);
      return;
    }

    await prefs.setString("access_token", refreshResult.accessToken);

    if (refreshResult.refreshToken != null) {
      await prefs.setString("refresh_token", refreshResult.refreshToken!);
    }

    request.extra["retried"] = true;
    request.headers["Authorization"] = "Bearer ${refreshResult.accessToken}";

    try {
      final response = await Dio(BaseOptions(baseUrl: dio.options.baseUrl)).fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<_RefreshResult?> _refreshToken(String refreshToken, RequestOptions request) async {
    try {
      final refreshDio = Dio(BaseOptions(baseUrl: request.baseUrl));

      final response = await refreshDio.post<Map<String, dynamic>>(
        "/auth/refresh",
        data: {"refresh_token": refreshToken, "mode": "json"},
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = response.data?["data"] as Map<String, dynamic>?;

      final accessToken = data?["access_token"]?.toString();

      final newRefreshToken = data?["refresh_token"]?.toString();

      if (accessToken == null) {
        return null;
      }

      return _RefreshResult(accessToken: accessToken, refreshToken: newRefreshToken);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400 || status == 401 || status == 403) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> _retryWithoutAuth(RequestOptions request, ErrorInterceptorHandler handler) async {
    request.extra["retried"] = true;
    request.headers.remove("Authorization");

    try {
      final response = await Dio(BaseOptions(baseUrl: dio.options.baseUrl)).fetch<dynamic>(request);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}

class _RefreshResult {
  final String accessToken;
  final String? refreshToken;

  const _RefreshResult({required this.accessToken, this.refreshToken});
}
