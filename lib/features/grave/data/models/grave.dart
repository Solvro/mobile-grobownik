import "package:freezed_annotation/freezed_annotation.dart";

import "../../../../common/models/location.dart";
import "achievement.dart";
import "grave_cemetery.dart";
import "subject.dart";

part "grave.freezed.dart";
part "grave.g.dart";

enum Status { published, draft, archived }

enum LocationPrecision { grave, field, unknown }

enum LocationSource { volunteer, grobonet, mogily, cui, spreadsheet, other }

@freezed
abstract class Grave with _$Grave {
  const factory Grave({
    required String id,
    required String firstName,
    required String lastName,
    @Default([]) List<Subject> subjects,
    String? education,
    Status? status,
    String? biography,
    @Default([]) List<Achievement> achievements,
    DateTime? birthDate,
    DateTime? deathDate,
    Location? location,
    GraveCemetery? cemetery,
    String? plot,
    String? directions,
    String? notes,
    @JsonKey(unknownEnumValue: LocationPrecision.unknown) LocationPrecision? locationPrecision,
    @JsonKey(unknownEnumValue: LocationSource.other) LocationSource? locationSource,
    String? locationSourceUrl,
    @JsonKey(name: "photos") @Default([]) List<String> photoIds,
  }) = _Grave;

  factory Grave.fromJson(Map<String, dynamic> json) => _$GraveFromJson(json);
}
