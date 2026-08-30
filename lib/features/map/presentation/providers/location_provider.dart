import "dart:async";
import "package:geolocator/geolocator.dart";
import "package:maplibre_gl/maplibre_gl.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "location_provider.g.dart";

@riverpod
class LocationState extends _$LocationState {
  var _initialized = false;
  Position? _currentPosition;
  var _hasPermission = false;

  @override
  AsyncValue<Position?> build() {
    if (!_initialized) {
      _initialized = true;
      unawaited(_initLocation());
    }
    return AsyncValue.data(_currentPosition);
  }

  Future<void> _initLocation() async {
    state = const AsyncValue.loading();
    try {
      _hasPermission = await _requestPermission();
      if (_hasPermission) {
        _currentPosition = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        state = AsyncValue.data(_currentPosition);
      } else {
        state = const AsyncValue.data(null);
      }
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> _requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      // TODO(permission): Handle permanently denied permission (e.g., surface state to UI and prompt to open app settings).
      return false;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<Position?> getPosition() async {
    if (_currentPosition != null) return _currentPosition;
    await refreshLocation();
    return _currentPosition;
  }

  Future<void> refreshLocation() async {
    if (!_hasPermission) {
      _hasPermission = await _requestPermission();
      if (!_hasPermission) {
        state = const AsyncValue.data(null);
        return;
      }
    }

    state = const AsyncValue.loading();
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      state = AsyncValue.data(_currentPosition);
    } on Object catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  LatLng? get currentLatLng {
    if (_currentPosition == null) return null;
    return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
  }

  bool get hasPermission => _hasPermission;
}
