import "dart:async";
import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/extensions/ref_extensions.dart";
import "../../../../common/network/directus_client.dart";
import "../models/grave.dart";

part "graves_repository.g.dart";

const _graveFields = "*,subjects.Subjects_id.*,achievements.Achievements_id.*,photos.directus_files_id";

@riverpod
Future<IList<Grave>> gravesRepository(Ref ref) async {
  final restClient = ref.watch(directusClientProvider);
  ref.setRefresh(DirectusConfig.gravesRefreshInterval);
  final gravesList = await restClient.fetchGraves();
  return gravesList.toIList();
}

@riverpod
Future<Grave> graveRepository(Ref ref, String graveId) {
  final restClient = ref.watch(directusClientProvider);
  ref.setRefresh(DirectusConfig.gravesRefreshInterval);

  return restClient.fetchGrave(graveId);
}

extension DioFetchGravesX on Dio {
  Future<List<Grave>> fetchGraves() async {
    try {
      final response = await get<Map<String, dynamic>>("/Graves", queryParameters: {"fields": _graveFields});
      final graves = response.data?["data"] as List? ?? [];

      return graves.map((dynamic item) => _parseGrave(item as Map)).toList();
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }

  Future<Grave> fetchGrave(String graveId) async {
    try {
      final response = await get<Map<String, dynamic>>("/Graves/$graveId", queryParameters: {"fields": _graveFields});

      return _parseGrave(response.data?["data"] as Map);
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

Grave _parseGrave(Map<dynamic, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  map["subjects"] = _unwrapJunction(map["subjects"], "Subjects_id");
  map["achievements"] = _unwrapJunction(map["achievements"], "Achievements_id");
  map["photos"] = _unwrapJunction(map["photos"], "directus_files_id");

  return Grave.fromJson(map);
}

List<dynamic> _unwrapJunction(dynamic relation, String relatedKey) {
  if (relation is! List) return const [];

  return relation.map((dynamic row) => row is Map ? row[relatedKey] : row).whereType<Object>().toList();
}
