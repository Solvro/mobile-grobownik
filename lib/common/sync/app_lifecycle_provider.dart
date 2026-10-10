import "dart:async";

import "package:flutter/widgets.dart" show AppLifecycleListener, AppLifecycleState;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "app_lifecycle_provider.g.dart";

/// Emits every change of the app lifecycle (resumed, paused, ...).
///
/// Kept as a provider (instead of creating the listener inside SyncController)
/// so that tests can replace it with their own stream.
@Riverpod(keepAlive: true)
Stream<AppLifecycleState> appLifecycleChanges(Ref ref) {
  final controller = StreamController<AppLifecycleState>();
  final listener = AppLifecycleListener(onStateChange: controller.add);

  ref.onDispose(() {
    listener.dispose();
    unawaited(controller.close());
  });

  return controller.stream;
}
