// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  visitedGravesCount: (json['visitedGravesCount'] as num?)?.toInt() ?? 0,
  visitHistory:
      (json['visitHistory'] as List<dynamic>?)
          ?.map((e) => VisitRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'visitedGravesCount': instance.visitedGravesCount,
      'visitHistory': instance.visitHistory,
    };
