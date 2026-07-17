import "package:freezed_annotation/freezed_annotation.dart";

import "location.dart";

part "visit_record.freezed.dart";
part "visit_record.g.dart";

@freezed
abstract class VisitRecord with _$VisitRecord {
  const factory VisitRecord({required int id, required String graveId, required Location location}) = _VisitRecord;

  factory VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);
}
