import "dart:async";

import "package:flutter/material.dart";
import "package:maplibre_gl/maplibre_gl.dart";

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = Completer<MapLibreMapController>();
  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14); // Wrocław

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      initialCameraPosition: _initial,
      onMapCreated: _controller.complete,
      styleString: "https://tiles.openfreemap.org/styles/liberty",
      myLocationEnabled: true,
      myLocationTrackingMode: MyLocationTrackingMode.tracking,
      myLocationRenderMode: MyLocationRenderMode.compass,
    );
  }
}