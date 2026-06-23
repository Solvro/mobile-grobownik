import "package:freezed_annotation/freezed_annotation.dart";

import "achievement.dart";
import "location.dart";
import "subject.dart";

part "grave.freezed.dart";
part "grave.g.dart";

@freezed
abstract class Grave with _$Grave {
  const factory Grave({
    required String id,
    required String firstName,
    required String lastName,
    @Default([]) List<Subject> subjects,
    String? education,
    String? biography,
    @Default([]) List<Achievement> achievements,
    DateTime? birthDate,
    DateTime? deathDate,
    required Location location,
    @Default([]) List<String> photoUrls,
  }) = _Grave;

  factory Grave.fromJson(Map<String, dynamic> json) => _$GraveFromJson(json);
}
