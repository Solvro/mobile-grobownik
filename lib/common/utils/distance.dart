import "package:geolocator/geolocator.dart";

import "../models/location.dart";

double? distanceToLocation(Position? userPosition, Location graveLocation) {
  if (userPosition == null) return null;

  return Geolocator.distanceBetween(
    userPosition.latitude,
    userPosition.longitude,
    graveLocation.latitude,
    graveLocation.longitude,
  );
}

String formatDistance(double? meters) {
  if (meters == null) return "—";
  if (meters < 1000) return "${meters.round()} m";

  return "${(meters / 1000).toStringAsFixed(1)} km";
}
