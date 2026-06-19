import "package:freezed_annotation/freezed_annotation.dart";

part "visit_record.freezed.dart";
part "visit_record.g.dart";

@freezed
abstract class VisitRecord with _$VisitRecord {
  const factory VisitRecord({required String id, required String graveId, required DateTime visitDate}) = _VisitRecord;

  factory VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);
}
