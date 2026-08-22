import "dart:async";

import "package:hooks_riverpod/hooks_riverpod.dart";

extension RefIntervalRefreshX on Ref {
  void setRefresh(Duration interval) {
    final timer = Timer(interval, () {
      if (mounted) invalidateSelf();
    });
    onDispose(timer.cancel);
  }
}
