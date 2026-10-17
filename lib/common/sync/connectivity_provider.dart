import "package:connectivity_plus/connectivity_plus.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "connectivity_provider.g.dart";

/// Emits the list of active network interfaces every time it changes.
///
/// Kept as a provider (instead of creating `Connectivity()` inside
/// SyncController) so that tests can replace it with their own stream.
@Riverpod(keepAlive: true)
Stream<List<ConnectivityResult>> connectivityChanges(Ref ref) {
  return Connectivity().onConnectivityChanged;
}
