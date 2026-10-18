import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../app/config/env.dart";
import "../../features/auth/data/auth_interceptor.dart";

part "directus_client.g.dart";

abstract class DirectusConfig {
  static final rootUrl = Env.directusUrl;

  static const headers = {"Accept": "application/json", "Accept-Encoding": "gzip", "Content-Type": "application/json"};
  static String assetUrl(String fileId) => "${rootUrl.replaceAll(RegExp(r"/+$"), "")}/assets/$fileId";
}

@Riverpod(keepAlive: true)
Dio directusClient(Ref ref) {
  return getDirectusClient();
}

Dio getDirectusClient() {
  final dio = Dio(BaseOptions(baseUrl: DirectusConfig.rootUrl, headers: DirectusConfig.headers));
  dio.interceptors.add(AuthInterceptor(dio));

  return dio;
}
