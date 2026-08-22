import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../../../app/config/env.dart";

class AuthService {
  static final rootUrl = Env.directusUrl;
  static const authEndpoint = "/auth/login";
  static String get apiFullUrl => rootUrl + authEndpoint;
  static final _dio = Dio();

  static Future<Map<String, String?>> getStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "email": prefs.getString("email"),
      "password": prefs.getString("password"),
      "access_token": prefs.getString("access_token"),
      "refresh_token": prefs.getString("refresh_token"),
    };
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token") != null;
  }

  static Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        apiFullUrl,
        data: {"email": email, "password": password, "mode": "json"},
      );

      if (response.statusCode == 200) {
        final data = response.data?["data"] as Map<String, dynamic>;
        final accessToken = data["access_token"];
        final refreshToken = data["refresh_token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        await prefs.setString("password", password);
        await prefs.setString("access_token", accessToken.toString());
        await prefs.setString("refresh_token", refreshToken.toString());

        return true;
      }
    } on DioException catch (_) {}

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
