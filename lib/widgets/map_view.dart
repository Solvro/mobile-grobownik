import "dart:async";

import "package:flutter/material.dart";
import "package:maplibre_gl/maplibre_gl.dart";

import "../services/location_permission_service.dart";

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = Completer<MapLibreMapController>();
  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14);

  var _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    unawaited(_requestLocation());
  }

  Future<void> _requestLocation() async {
    final granted = await const LocationPermissionService().requestPermission();
    if (!mounted) return;
    setState(() => _hasLocationPermission = granted);
  }

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      initialCameraPosition: _initial,
      onMapCreated: _controller.complete,
      styleString: "https://tiles.openfreemap.org/styles/liberty",
      myLocationEnabled: _hasLocationPermission,
      myLocationTrackingMode: _hasLocationPermission ? MyLocationTrackingMode.tracking : MyLocationTrackingMode.none,
      myLocationRenderMode: _hasLocationPermission ? MyLocationRenderMode.compass : MyLocationRenderMode.normal,
    );
  }
}
