import "package:freezed_annotation/freezed_annotation.dart";

part "location.freezed.dart";
part "location.g.dart";

@freezed
abstract class Location with _$Location {
  const factory Location({required String type, required List<double> coordinates}) = _Location;
  const Location._();

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;
}
