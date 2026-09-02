import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/extensions/ref_extensions.dart";
import "../../../../common/network/directus_client.dart";
import "../models/cemetery.dart";

part "cemeteries_repository.g.dart";

@riverpod
Future<IList<Cemetery>> cemeteriesRepository(Ref ref) async {
  final restClient = ref.watch(directusClientProvider);
  ref.setRefresh(DirectusConfig.cemeteriesRefreshInterval);
  final cemeteries = await restClient.fetchCemeteries();
  return cemeteries.toIList();
}

extension DioFetchCemeteriesX on Dio {
  Future<List<Cemetery>> fetchCemeteries() async {
    try {
      final response = await get<Map<String, dynamic>>("/Cemeteries");
      final cemeteries = response.data?["data"] as List? ?? [];

      return cemeteries.map((dynamic item) => _parseCemetery(item as Map<dynamic, dynamic>)).toList();
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }
}

Cemetery _parseCemetery(Map<dynamic, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  final boundary = map["boundary"];
  if (boundary is Map<String, dynamic>) {
    map["boundary"] = boundary;
  } else if (boundary is Map<dynamic, dynamic>) {
    map["boundary"] = Map<String, dynamic>.from(boundary);
  }

  return Cemetery.fromJson(map);
}
