import "package:geolocator/geolocator.dart";

enum LocationPermissionStatus {
  granted,
  denied,
  serviceDisabled,
}

class LocationPermissionService {
  const LocationPermissionService();

  Future<LocationPermissionStatus> requestPermission() async {
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) return LocationPermissionStatus.serviceDisabled;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    switch (perm) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.denied;
    }
  }

  Future<void> openAppSettings() => Geolocator.openAppSettings();

  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}