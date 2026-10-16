import "package:drift/drift.dart";
import "package:drift_flutter/drift_flutter.dart";

part "app_database.g.dart";

const _lastSyncedAtKey = "last_synced_at";

/// One row per grave. The whole `Grave` model is kept as JSON in [payload]
/// (subjects, achievements and photo ids included); the other columns exist
/// only for ordering and for future SQL-side searching.
@DataClassName("GraveRow")
class Graves extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get payload => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Small key-value table (currently only `last_synced_at`).
@DataClassName("SyncMetaRow")
class SyncMeta extends Table {
  TextColumn get metaKey => text()();
  TextColumn get metaValue => text()();

  @override
  Set<Column> get primaryKey => {metaKey};
}

@DriftDatabase(tables: [Graves, SyncMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: "grobownik"));

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  /// All graves, re-emitted every time the table changes.
  Stream<List<GraveRow>> watchGraveRows() {
    final query = select(graves)..orderBy([(t) => OrderingTerm.asc(t.lastName), (t) => OrderingTerm.asc(t.firstName)]);

    return query.watch();
  }

  /// A single grave; emits `null` when it is not in the database.
  Stream<GraveRow?> watchGraveRow(String id) {
    return (select(graves)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Replaces the whole content of the database in one transaction, so
  /// watchers see either the old data or the new data, never a half-written
  /// state. Also stores the time of the sync.
  Future<void> replaceAllGraves(List<GravesCompanion> rows, {required DateTime syncedAt}) {
    return transaction(() async {
      await delete(graves).go();
      await batch((b) {
        b.insertAll(graves, rows, mode: InsertMode.insertOrReplace);
      });
      await into(syncMeta).insertOnConflictUpdate(
        SyncMetaCompanion.insert(metaKey: _lastSyncedAtKey, metaValue: syncedAt.toUtc().toIso8601String()),
      );
    });
  }

  Future<DateTime?> readLastSyncedAt() async {
    final row = await (select(syncMeta)..where((t) => t.metaKey.equals(_lastSyncedAtKey))).getSingleOrNull();
    if (row == null) return null;

    return DateTime.tryParse(row.metaValue);
  }
}
