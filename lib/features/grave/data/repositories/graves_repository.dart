import "dart:convert";

import "package:dio/dio.dart";
import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/database/app_database.dart";
import "../../../../common/database/app_database_provider.dart";
import "../models/grave.dart";

part "graves_repository.g.dart";

const _graveFields =
    "*,cemetery.id,cemetery.name,cemetery.address,subjects.Subjects_id.*,achievements.Achievements_id.*,photos.directus_files_id";

/// Directus returns only 100 items by default; -1 means "no limit". Without
/// it, graves beyond the first 100 would never reach the local database.
const _noLimit = -1;

class DirectusOfflineException implements Exception {
  const DirectusOfflineException(this.cause);

  final DioException cause;

  @override
  String toString() => "DirectusOfflineException: ${cause.message ?? cause.type.name}";
}

/// All graves, read from the local database. The network never feeds the UI
/// directly: SyncController downloads graves into the database and this
/// stream re-emits whenever the database changes.
@riverpod
Stream<IList<Grave>> gravesRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);

  return database.watchGraveRows().map((rows) => rows.map((row) => row.toGrave()).nonNulls.toIList());
}

/// A single grave from the local database; `null` when it is not there.
@riverpod
Stream<Grave?> graveRepository(Ref ref, String graveId) {
  final database = ref.watch(appDatabaseProvider);

  return database.watchGraveRow(graveId).map((row) => row?.toGrave());
}

extension GraveRowX on GraveRow {
  /// Returns `null` for a row that cannot be decoded, so one damaged row
  /// does not take the whole list down.
  Grave? toGrave() {
    try {
      return Grave.fromJson(jsonDecode(payload) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }
}

extension GraveToRowX on Grave {
  GravesCompanion toCompanion() {
    return GravesCompanion.insert(id: id, firstName: firstName, lastName: lastName, payload: jsonEncode(toJson()));
  }
}

extension DioFetchGravesX on Dio {
  Future<List<Grave>> fetchGraves() async {
    try {
      final response = await get<Map<String, dynamic>>(
        "/items/Graves",
        queryParameters: {"fields": _graveFields, "limit": _noLimit},
      );
      final graves = response.data?["data"] as List? ?? [];

      return graves.whereType<Map<dynamic, dynamic>>().map(_tryParseGrave).nonNulls.toList();
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

Grave? _tryParseGrave(Map<dynamic, dynamic> raw) {
  try {
    return _parseGrave(raw);
  } on Object {
    return null;
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
