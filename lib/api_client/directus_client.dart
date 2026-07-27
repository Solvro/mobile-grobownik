import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../config/env.dart";

part "directus_client.g.dart";

abstract class DirectusConfig {
  static const gravesRefreshInterval = Duration(seconds: 15);
  static final rootUrl = Env.directusUrl;
  static const itemsEndpoint = "/items";
  static String get apiFullUrl => rootUrl + itemsEndpoint;

  static final headers = {
    "Accept": "application/json",
    "Accept-Encoding": "gzip",
    "Content-Type": "application/json",
    "Authorization": "Bearer ${Env.directusStaticToken}",
  };
}

@riverpod
Dio directusClient(Ref ref) {
  return getDirectusClient();
}

Dio getDirectusClient() {
  return Dio(BaseOptions(baseUrl: DirectusConfig.apiFullUrl, headers: DirectusConfig.headers));
}
