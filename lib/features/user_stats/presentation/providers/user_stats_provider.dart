import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../models/user_stats.dart";
import "../../../../repository/visits_repository.dart";

part "user_stats_provider.g.dart";

@riverpod
class UserStatsController extends _$UserStatsController {
  @override
  Future<UserStats> build() => ref.watch(visitsRepositoryProvider.notifier).getUserStats();
}
