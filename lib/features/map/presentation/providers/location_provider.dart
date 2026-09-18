import "dart:async";
import "package:geolocator/geolocator.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "location_provider.g.dart";

enum LocationAccess {
  granted,
  denied,
  deniedForever,
  serviceDisabled;

  bool get isGranted => this == LocationAccess.granted;
}

typedef LocationSnapshot = ({Position? position, LocationAccess access});

@riverpod
class LocationState extends _$LocationState {
  var _initialized = false;
  LocationSnapshot _snapshot = (position: null, access: LocationAccess.denied);

  @override
  AsyncValue<LocationSnapshot> build() {
    if (!_initialized) {
      _initialized = true;
      unawaited(refreshLocation());
    }

    return AsyncValue.data(_snapshot);
  }

  Future<void> refreshLocation() async {
    state = const AsyncValue.loading();
    try {
      final access = await _resolveAccess();
      if (!access.isGranted) {
        _emit((position: null, access: access));

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      _emit((position: position, access: LocationAccess.granted));
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void _emit(LocationSnapshot snapshot) {
    _snapshot = snapshot;
    state = AsyncValue.data(snapshot);
  }

  Future<LocationAccess> _resolveAccess() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccess.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.always || LocationPermission.whileInUse => LocationAccess.granted,
      LocationPermission.deniedForever => LocationAccess.deniedForever,
      _ => LocationAccess.denied,
    };
  }

  Future<Position?> getPosition() async {
    if (_snapshot.position != null) return _snapshot.position;
    await refreshLocation();

    return _snapshot.position;
  }
}
