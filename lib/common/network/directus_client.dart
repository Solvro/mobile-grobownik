import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../app/config/env.dart";

part "directus_client.g.dart";

abstract class DirectusConfig {
  static const gravesRefreshInterval = Duration(seconds: 15);
  static final rootUrl = Env.directusUrl;
  static const itemsEndpoint = "/items";
  static String get apiFullUrl => rootUrl + itemsEndpoint;

  static const headers = {"Accept": "application/json", "Accept-Encoding": "gzip", "Content-Type": "application/json"};
  static String assetUrl(String fileId) => "${rootUrl.replaceAll(RegExp(r"/+$"), "")}/assets/$fileId";
}

@riverpod
Dio directusClient(Ref ref) {
  return getDirectusClient();
}

Dio getDirectusClient() {
  return Dio(BaseOptions(baseUrl: DirectusConfig.apiFullUrl, headers: DirectusConfig.headers));
}
