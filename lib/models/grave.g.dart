// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grave.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Grave _$GraveFromJson(Map<String, dynamic> json) => _Grave(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  subjects:
      (json['subjects'] as List<dynamic>?)
          ?.map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  education: json['education'] as String?,
  biography: json['biography'] as String?,
  achievements:
      (json['achievements'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  deathDate: json['deathDate'] == null
      ? null
      : DateTime.parse(json['deathDate'] as String),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$GraveToJson(_Grave instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'subjects': instance.subjects,
  'education': instance.education,
  'biography': instance.biography,
  'achievements': instance.achievements,
  'birthDate': instance.birthDate?.toIso8601String(),
  'deathDate': instance.deathDate?.toIso8601String(),
  'location': instance.location,
  'photoUrls': instance.photoUrls,
};
