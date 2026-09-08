import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../visits/data/repositories/visits_repository.dart";
import "../../data/models/user_stats.dart";

part "user_stats_provider.g.dart";

@riverpod
class UserStatsController extends _$UserStatsController {
  @override
  Future<UserStats> build() => ref.watch(visitsRepositoryProvider.notifier).getUserStats();
}
