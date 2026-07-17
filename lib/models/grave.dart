import "package:freezed_annotation/freezed_annotation.dart";

import "achievement.dart";
import "location.dart";
import "subject.dart";

part "grave.freezed.dart";
part "grave.g.dart";

enum Status { published, draft, archived }

@freezed
abstract class Grave with _$Grave {
  const factory Grave({
    required String id,
    required String firstName,
    required String lastName,
    @Default([]) List<Subject> subjects,
    String? education,
    required Status status,
    String? biography,
    @Default([]) List<Achievement> achievements,
    DateTime? birthDate,
    DateTime? deathDate,
    required Location location,
    @JsonKey(name: "photos") @Default([]) List<int> photoIds,
  }) = _Grave;

  factory Grave.fromJson(Map<String, dynamic> json) => _$GraveFromJson(json);
}
