import "dart:async";
import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../api_client/directus_client.dart";
import "../models/grave.dart";
import "../utils/ref_extensions.dart";

part "graves_repository.g.dart";

class DirectusOfflineException implements Exception {}

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
      final gravesRes = await get<Map<String, dynamic>>(
        "/Graves",
        queryParameters: {"fields": "*,subjects.*,achievements.*"},
      );

      final subjectsRes = await get<Map<String, dynamic>>("/Subjects");
      final achievementsRes = await get<Map<String, dynamic>>("/Achievements");

      final gravesList = gravesRes.data?["data"] as List? ?? [];
      final subjectsList = subjectsRes.data?["data"] as List? ?? [];
      final achievementsList = achievementsRes.data?["data"] as List? ?? [];

      return gravesList.map((dynamic item) {
        final map = Map<String, dynamic>.from(item as Map);

        if (map["subjects"] is List) {
          final subjectIds = (map["subjects"] as List).map((dynamic j) => (j as Map)["Subjects_id"]).toList();

          map["subjects"] = subjectsList.where((dynamic s) => subjectIds.contains((s as Map)["id"])).toList();
        }

        if (map["achievements"] is List) {
          final achIds = (map["achievements"] as List).map((dynamic j) => (j as Map)["Achievements_id"]).toList();

          map["achievements"] = achievementsList.where((dynamic a) => achIds.contains((a as Map)["id"])).toList();
        }

        return Grave.fromJson(map);
      }).toList();
    } on DioException catch (e) {
      throw DirectusOfflineException();
    }
  }

  Future<void> updateGraveStatus(String graveId, String newStatus) async {
    try {
      await patch<Map<String, dynamic>>("/Graves/$graveId", data: {"status": newStatus});
    } on DioException catch (_) {
      throw DirectusOfflineException();
    }
  }
}
