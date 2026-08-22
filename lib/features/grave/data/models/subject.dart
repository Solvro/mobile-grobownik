import "package:freezed_annotation/freezed_annotation.dart";

part "subject.freezed.dart";
part "subject.g.dart";

@freezed
abstract class Subject with _$Subject {
  const factory Subject({required String id, required String name, String? faculty}) = _Subject;

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
}
