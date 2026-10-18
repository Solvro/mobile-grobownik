import "package:freezed_annotation/freezed_annotation.dart";

part "grave_cemetery.freezed.dart";
part "grave_cemetery.g.dart";

@freezed
abstract class GraveCemetery with _$GraveCemetery {
  const factory GraveCemetery({required String id, required String name, String? address}) = _GraveCemetery;

  factory GraveCemetery.fromJson(Map<String, dynamic> json) => _$GraveCemeteryFromJson(json);
}
