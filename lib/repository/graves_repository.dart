import "dart:async";
import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api_client/directus_client.dart";
import "../models/grave.dart";
import "../utils/ref_extensions.dart";

part "graves_repository.g.dart";

class DirectusOfflineException implements Exception {
  const DirectusOfflineException(this.cause);

  final DioException cause;

  @override
  String toString() => "DirectusOfflineException: ${cause.message ?? cause.type.name}";
}

@riverpod
Future<IList<Grave>> gravesRepository(Ref ref) async {
  final restClient = ref.watch(directusClientProvider);
  ref.setRefresh(DirectusConfig.gravesRefreshInterval);
  final gravesList = await restClient.fetchGraves();
  return gravesList.toIList();
}

extension DioFetchGravesX on Dio {
  Future<List<Grave>> fetchGraves() async {
    try {
      final response = await get<Map<String, dynamic>>(
        "/Graves",
        queryParameters: {"fields": "*,subjects.Subjects_id.*,achievements.Achievements_id.*,photos.directus_files_id"},
      );

      final graves = response.data?["data"] as List? ?? [];

      return graves.map((dynamic item) {
        final map = Map<String, dynamic>.from(item as Map);
        map["subjects"] = _unwrapJunction(map["subjects"], "Subjects_id");
        map["achievements"] = _unwrapJunction(map["achievements"], "Achievements_id");
        map["photos"] = _unwrapJunction(map["photos"], "directus_files_id");

        return Grave.fromJson(map);
      }).toList();
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }

  Future<void> updateGraveStatus(String graveId, String newStatus) async {
    try {
      await patch<Map<String, dynamic>>("/Graves/$graveId", data: {"status": newStatus});
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }
}

List<dynamic> _unwrapJunction(dynamic relation, String relatedKey) {
  if (relation is! List) return const [];

  return relation.map((dynamic row) => row is Map ? row[relatedKey] : row).whereType<Object>().toList();
}
