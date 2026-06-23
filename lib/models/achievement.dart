import "package:freezed_annotation/freezed_annotation.dart";

part "achievement.freezed.dart";
part "achievement.g.dart";

@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({required String id, required String name, String? description, DateTime? date}) =
      _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
}
