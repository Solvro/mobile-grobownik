import "package:freezed_annotation/freezed_annotation.dart";

import "../../../../common/models/location.dart";

part "visit_record.freezed.dart";
part "visit_record.g.dart";

@freezed
abstract class VisitGrave with _$VisitGrave {
  const factory VisitGrave({
    required String id,
    String? firstName,
    String? lastName,
    @JsonKey(name: "photos") @Default([]) List<String> photoIds,
  }) = _VisitGrave;

  const VisitGrave._();

  factory VisitGrave.fromJson(Map<String, dynamic> json) => _$VisitGraveFromJson(json);

  String get displayName {
    final name = "${firstName ?? ""} ${lastName ?? ""}".trim();
    return name.isEmpty ? id : name;
  }
}

@freezed
abstract class VisitRecord with _$VisitRecord {
  const factory VisitRecord({
    required int id,
    @JsonKey(fromJson: visitGraveFromJson) required VisitGrave grave,
    @JsonKey(name: "submit_location") required Location location,
    @JsonKey(name: "date_created") DateTime? visitedAt,
  }) = _VisitRecord;

  const VisitRecord._();

  factory VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);

  String get graveId => grave.id;
}

VisitGrave visitGraveFromJson(Object? json) {
  if (json is String) {
    return VisitGrave(id: json);
  }

  if (json is Map) {
    final map = Map<String, dynamic>.from(json);
    map["photos"] = _unwrapPhotoIds(map["photos"]);
    return VisitGrave.fromJson(map);
  }

  throw ArgumentError.value(json, "json", "Expected a grave id String or Map");
}

List<String> _unwrapPhotoIds(Object? photos) {
  if (photos is! List) return const [];

  return photos
      .map((dynamic row) {
        if (row is String) return row;
        if (row is Map) return row["directus_files_id"] as String?;
        return null;
      })
      .whereType<String>()
      .toList();
}
