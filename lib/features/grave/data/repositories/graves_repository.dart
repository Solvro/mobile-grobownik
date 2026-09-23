import "dart:async";

import "package:connectivity_plus/connectivity_plus.dart";
import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/network/directus_client.dart";
import "../../../../common/services/graves_cache.dart";
import "../models/grave.dart";

part "graves_repository.g.dart";

const _graveFields = "*,subjects.Subjects_id.*,achievements.Achievements_id.*,photos.directus_files_id";

class DirectusOfflineException implements Exception {
  const DirectusOfflineException(this.cause);

  final DioException cause;

  @override
  String toString() => "DirectusOfflineException: ${cause.message ?? cause.type.name}";
}

@riverpod
Future<IList<Grave>> gravesRepository(Ref ref) async {
  final restClient = ref.watch(directusClientProvider);
  final cache = await GravesCache.open();
  return _fetchWithCache(
    ref,
    fetch: () async => (await restClient.fetchGraves()).toIList(),
    save: cache.saveAll,
    restore: cache.readAll,
  );
}

@riverpod
Future<Grave> graveRepository(Ref ref, String graveId) async {
  final restClient = ref.watch(directusClientProvider);
  final cache = await GravesCache.open();
  return _fetchWithCache(
    ref,
    fetch: () => restClient.fetchGrave(graveId),
    save: cache.save,
    restore: () => cache.read(graveId),
  );
}

Future<T> _fetchWithCache<T extends Object>(
  Ref ref, {
  required Future<T> Function() fetch,
  required Future<void> Function(T) save,
  required T? Function() restore,
}) async {
  try {
    final value = await fetch();
    await save(value);
    return value;
  } on DirectusOfflineException {
    await _invalidateWhenOnline(ref);
    final cached = restore();
    if (cached == null) rethrow;
    return cached;
  }
}

Future<void> _invalidateWhenOnline(Ref ref) async {
  final connectivity = Connectivity();
  final current = await connectivity.checkConnectivity();
  if (!current.contains(ConnectivityResult.none)) return;
  late StreamSubscription<List<ConnectivityResult>> sub;
  sub = connectivity.onConnectivityChanged.listen((result) {
    if (!result.contains(ConnectivityResult.none)) {
      unawaited(sub.cancel());
      ref.invalidateSelf();
    }
  });
  ref.onDispose(() => unawaited(sub.cancel()));
}

extension DioFetchGravesX on Dio {
  Future<List<Grave>> fetchGraves() async {
    try {
      final response = await get<Map<String, dynamic>>("/items/Graves", queryParameters: {"fields": _graveFields});
      final graves = response.data?["data"] as List? ?? [];

      return graves.map((dynamic item) => _parseGrave(item as Map)).toList();
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }

  Future<Grave> fetchGrave(String graveId) async {
    try {
      final response = await get<Map<String, dynamic>>(
        "/items/Graves/$graveId",
        queryParameters: {"fields": _graveFields},
      );

      return _parseGrave(response.data?["data"] as Map);
    } on DioException catch (e, stackTrace) {
      Error.throwWithStackTrace(DirectusOfflineException(e), stackTrace);
    }
  }

  Future<void> updateGraveStatus(String graveId, String newStatus) async {
    try {
      await patch<Map<String, dynamic>>("/items/Graves/$graveId", data: {"status": newStatus});
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
