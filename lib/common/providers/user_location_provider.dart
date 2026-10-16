import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../features/map/presentation/providers/location_provider.dart";

part "user_location_provider.g.dart";

@riverpod
Stream<Position?> userLocation(Ref ref) async* {
  final granted = ref.watch(locationStateProvider.select((state) => state.value?.access.isGranted ?? false));
  if (!granted) {
    yield null;
    return;
  }

  yield* Geolocator.getPositionStream(
    locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
  );
}
