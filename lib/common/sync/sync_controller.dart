import "dart:async";
import "dart:ui" show AppLifecycleState;

import "package:connectivity_plus/connectivity_plus.dart";
import "package:dio/dio.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../../features/grave/data/repositories/graves_repository.dart";
import "../database/app_database_provider.dart";
import "../network/directus_client.dart";
import "app_lifecycle_provider.dart";
import "connectivity_provider.dart";
import "sync_status.dart";

part "sync_controller.g.dart";

const _syncTimeout = Duration(seconds: 30);

// Keys of the old shared_preferences grave cache (removed together with
// GravesCache). Safe to delete this clean-up after a few releases.
const _legacyGravesKey = "_graves_cache__";
const _legacyGraveKeyPrefix = "_grave_cache__";

/// How old the data may get before returning to the app triggers a new sync.
///
/// A provider (and not a plain constant) so that tests can change it.
@Riverpod(keepAlive: true)
Duration syncResumeInterval(Ref ref) => const Duration(minutes: 5);

/// Downloads all graves from Directus into the local database.
///
/// Plain `Notifier` (not an `AsyncNotifier`) on purpose: a failed sync must
/// not look like "no data". The UI reads graves from the database and only
/// shows this status next to them.
@Riverpod(keepAlive: true)
class SyncController extends _$SyncController {
  var _running = false;
  var _offline = false;

  @override
  SyncStatus build() {
    ref.listen(connectivityChangesProvider, (previous, next) {
      if (next case AsyncData(:final value)) _onConnectivityChanged(value);
    });

    ref.listen(appLifecycleChangesProvider, (previous, next) {
      if (next case AsyncData(:final value)) _onLifecycleChanged(value);
    });

    unawaited(_start());

    return const SyncIdle();
  }

  Future<void> _start() async {
    unawaited(_removeLegacyCache());

    DateTime? lastSyncedAt;
    try {
      lastSyncedAt = await ref.read(appDatabaseProvider).readLastSyncedAt();
    } on Object {
      lastSyncedAt = null;
    }
    if (!ref.mounted) return;

    if (state is SyncIdle) state = SyncIdle(lastSyncedAt: lastSyncedAt);

    await sync();
  }

  /// connectivity_plus only knows whether a network interface is up, so this
  /// is just a hint to try again. A failing request is what counts as offline.
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    final offline = results.contains(ConnectivityResult.none);
    final wasOffline = _offline;
    _offline = offline;

    if (offline) return;
    if (wasOffline || state is SyncFailure) unawaited(sync());
  }

  /// The app can stay in the background for hours without being restarted, so
  /// neither the start-up sync nor a connectivity change would refresh it.
  void _onLifecycleChanged(AppLifecycleState lifecycle) {
    if (lifecycle != AppLifecycleState.resumed) return;
    if (_needsRefresh()) unawaited(sync());
  }

  bool _needsRefresh() {
    final status = state;
    if (status is SyncFailure) return true;

    final lastSyncedAt = status.lastSyncedAt;
    if (lastSyncedAt == null) return true;

    final age = DateTime.now().toUtc().difference(lastSyncedAt);

    return age >= ref.read(syncResumeIntervalProvider);
  }

  /// Safe to call repeatedly: calls made while a sync is running are ignored.
  Future<void> sync() async {
    if (_running) return;
    _running = true;

    final previousSyncedAt = state.lastSyncedAt;
    state = SyncInProgress(lastSyncedAt: previousSyncedAt);

    try {
      final graves = await ref.read(directusClientProvider).fetchGraves().timeout(_syncTimeout);

      final syncedAt = DateTime.now().toUtc();
      await ref.read(appDatabaseProvider).replaceAllGraves([
        for (final grave in graves) grave.toCompanion(),
      ], syncedAt: syncedAt);

      if (ref.mounted) state = SyncSuccess(lastSyncedAt: syncedAt);
    } on Object catch (error) {
      // The database is left untouched on failure.
      if (ref.mounted) {
        state = SyncFailure(error: error, isOffline: _isOfflineError(error), lastSyncedAt: previousSyncedAt);
      }
    } finally {
      _running = false;
    }
  }

  static bool _isOfflineError(Object error) {
    if (error is TimeoutException) return true;

    final DioException? cause = switch (error) {
      DirectusOfflineException(:final cause) => cause,
      DioException() => error,
      _ => null,
    };

    return switch (cause?.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => true,
      _ => false,
    };
  }

  Future<void> _removeLegacyCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyKeys = prefs
          .getKeys()
          .where((key) => key == _legacyGravesKey || key.startsWith(_legacyGraveKeyPrefix))
          .toList();
      for (final key in legacyKeys) {
        await prefs.remove(key);
      }
    } on Object {
      // Best effort only; leftover keys are harmless.
    }
  }
}
