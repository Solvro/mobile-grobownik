import "package:geolocator/geolocator.dart";

class LocationPermissionService {
  const LocationPermissionService();

  Future<bool> requestPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }

    return perm == LocationPermission.always || perm == LocationPermission.whileInUse;
  }
}
