import "package:geolocator/geolocator.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../services/location_permission_service.dart";

part "user_location_provider.g.dart";

@riverpod
Stream<Position?> userLocation(Ref ref) async* {
  final granted = await const LocationPermissionService().requestPermission();
  if (!granted) {
    yield null;
    return;
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
  );
}
