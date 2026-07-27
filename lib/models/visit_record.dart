import "package:freezed_annotation/freezed_annotation.dart";

import "location.dart";

part "visit_record.freezed.dart";
part "visit_record.g.dart";

@freezed
abstract class VisitRecord with _$VisitRecord {
  const factory VisitRecord({
    required int id,
    @JsonKey(name: "grave") required String graveId,
    @JsonKey(name: "submit_location") required Location location,
    @JsonKey(name: "date_created") DateTime? visitedAt,
  }) = _VisitRecord;

  factory VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);
}
