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

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refresh_token");

      if (refreshToken != null) {
        try {
          final refreshDio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));

          final response = await refreshDio.post<Map<String, dynamic>>(
            "/auth/refresh",
            data: {"refresh_token": refreshToken, "mode": "json"},
          );

          if (response.statusCode == 200) {
            final data = response.data?["data"] as Map<String, dynamic>;
            final newAccessToken = data["access_token"];
            final newRefreshToken = data["refresh_token"];

            await prefs.setString("access_token", newAccessToken.toString());
            await prefs.setString("refresh_token", newRefreshToken.toString());

            err.requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

            final retryResponse = await dio.fetch<dynamic>(err.requestOptions);
            return handler.resolve(retryResponse);
          }
        } on DioException catch (_) {
          await prefs.clear();
        }
      }
    }

    return handler.next(err);
  }
}
