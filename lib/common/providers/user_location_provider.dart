import "package:geolocator/geolocator.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/map/presentation/providers/location_provider.dart";

part "user_location_provider.g.dart";

@riverpod
Stream<Position?> userLocation(Ref ref) async* {
  final access = ref.watch(locationStateProvider).value?.access;
  if (access == null || !access.isGranted) {
    yield null;
    return;
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
  );
}
