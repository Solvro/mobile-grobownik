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

  bool contains(double longitude, double latitude) {
    for (final polygon in boundary.polygons) {
      if (polygon.isEmpty) continue;
      if (!_ringContains(polygon.first, longitude, latitude)) continue;
      final inHole = polygon.skip(1).any((hole) => _ringContains(hole, longitude, latitude));
      if (!inHole) return true;
    }
    return false;
  }

  ({double latitude, double longitude})? get labelAnchor {
    List<List<double>>? bestRing;
    var bestArea = -1.0;

    for (final polygon in boundary.polygons) {
      if (polygon.isEmpty) continue;
      final ring = polygon.first;
      final area = _ringBBoxArea(ring);
      if (area <= bestArea) continue;
      bestArea = area;
      bestRing = ring;
    }

    if (bestRing == null) return null;
    return _ringCentroid(bestRing);
  }
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

bool _ringContains(List<List<double>> ring, double longitude, double latitude) {
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    if (ring[i].length < 2 || ring[j].length < 2) continue;
    final xi = ring[i][0];
    final yi = ring[i][1];
    final xj = ring[j][0];
    final yj = ring[j][1];
    final intersects = (yi > latitude) != (yj > latitude) && longitude < (xj - xi) * (latitude - yi) / (yj - yi) + xi;
    if (intersects) inside = !inside;
  }
  return inside;
}

double _ringBBoxArea(List<List<double>> ring) {
  var minLng = double.infinity;
  var maxLng = -double.infinity;
  var minLat = double.infinity;
  var maxLat = -double.infinity;

  for (final point in ring) {
    if (point.length < 2) continue;
    final lng = point[0];
    final lat = point[1];
    minLng = lng < minLng ? lng : minLng;
    maxLng = lng > maxLng ? lng : maxLng;
    minLat = lat < minLat ? lat : minLat;
    maxLat = lat > maxLat ? lat : maxLat;
  }

  if (minLng == double.infinity) return 0;
  return (maxLng - minLng) * (maxLat - minLat);
}

({double latitude, double longitude})? _ringCentroid(List<List<double>> ring) {
  var latitude = 0.0;
  var longitude = 0.0;
  var count = 0;

  for (var i = 0; i < ring.length; i++) {
    final point = ring[i];
    if (point.length < 2) continue;
    if (i == ring.length - 1 && count > 0 && point[0] == ring.first[0] && point[1] == ring.first[1]) {
      continue;
    }
    longitude += point[0];
    latitude += point[1];
    count++;
  }

  if (count == 0) return null;
  return (latitude: latitude / count, longitude: longitude / count);
}
