sealed class SyncStatus {
  const SyncStatus();

  DateTime? get lastSyncedAt;
}

final class SyncIdle extends SyncStatus {
  const SyncIdle({this.lastSyncedAt});

  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() => "SyncIdle(lastSyncedAt: $lastSyncedAt)";
}

final class SyncInProgress extends SyncStatus {
  const SyncInProgress({this.lastSyncedAt});

  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() => "SyncInProgress(lastSyncedAt: $lastSyncedAt)";
}

final class SyncSuccess extends SyncStatus {
  const SyncSuccess({required this.lastSyncedAt});

  @override
  final DateTime lastSyncedAt;

  @override
  String toString() => "SyncSuccess(lastSyncedAt: $lastSyncedAt)";
}

/// The last sync failed. Local data (if any) is still usable.
final class SyncFailure extends SyncStatus {
  const SyncFailure({required this.error, required this.isOffline, this.lastSyncedAt});

  final Object error;

  /// `true` for connection errors and timeouts, `false` for everything else
  /// (HTTP errors, malformed data, ...).
  final bool isOffline;

  @override
  final DateTime? lastSyncedAt;

  @override
  String toString() => "SyncFailure(isOffline: $isOffline, lastSyncedAt: $lastSyncedAt, error: $error)";
}
