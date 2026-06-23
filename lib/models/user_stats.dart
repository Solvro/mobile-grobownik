import "package:freezed_annotation/freezed_annotation.dart";

import "visit_record.dart";

part "user_stats.freezed.dart";
part "user_stats.g.dart";

@freezed
abstract class UserStats with _$UserStats {
  const factory UserStats({@Default(0) int visitedGravesCount, @Default([]) List<VisitRecord> visitHistory}) =
      _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);
}
