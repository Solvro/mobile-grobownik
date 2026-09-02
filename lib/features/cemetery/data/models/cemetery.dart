import "package:freezed_annotation/freezed_annotation.dart";

part "cemetery.freezed.dart";
part "cemetery.g.dart";

@freezed
abstract class CemeteryBoundary with _$CemeteryBoundary {
  const factory CemeteryBoundary({required String type, required List<Object> coordinates}) = _CemeteryBoundary;
  const CemeteryBoundary._();

  factory CemeteryBoundary.fromJson(Map<String, dynamic> json) => _$CemeteryBoundaryFromJson(json);

  /// MultiPolygon-normalized rings of `[longitude, latitude]` points.
  List<List<List<List<double>>>> get polygons {
    final depth = _coordinateDepth(coordinates);
    if (type == "MultiPolygon" || depth >= 4) {
      return [for (final polygon in coordinates) _asRings(polygon)];
    }
    if (type == "Polygon" || depth >= 3) {
      return [_asRings(coordinates)];
    }
    return const [];
  }
}

@freezed
abstract class Cemetery with _$Cemetery {
  const factory Cemetery({
    required String id,
    required String name,
    String? address,
    required CemeteryBoundary boundary,
  }) = _Cemetery;
  const Cemetery._();

  factory Cemetery.fromJson(Map<String, dynamic> json) => _$CemeteryFromJson(json);
}

List<Object> _jsonList(Object raw) {
  if (raw is List<Object>) return raw;
  if (raw is List<dynamic>) return List<Object>.from(raw);
  return const [];
}

int _coordinateDepth(Object value) {
  var depth = 0;
  var items = _jsonList(value);
  while (items.isNotEmpty) {
    depth++;
    items = _jsonList(items.first);
  }
  return depth;
}

List<List<List<double>>> _asRings(Object raw) {
  return [for (final ring in _jsonList(raw)) _asRing(ring)];
}

List<List<double>> _asRing(Object raw) {
  return [for (final point in _jsonList(raw)) _asPoint(point)];
}

List<double> _asPoint(Object raw) {
  final coords = _jsonList(raw);
  if (coords.length < 2) return const [];
  return [(coords[0] as num).toDouble(), (coords[1] as num).toDouble()];
}
