// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VisitRecord _$VisitRecordFromJson(Map<String, dynamic> json) => _VisitRecord(
  id: json['id'] as String,
  graveId: json['graveId'] as String,
  visitDate: DateTime.parse(json['visitDate'] as String),
);

Map<String, dynamic> _$VisitRecordToJson(_VisitRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'graveId': instance.graveId,
      'visitDate': instance.visitDate.toIso8601String(),
    };
