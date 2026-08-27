import "dart:async";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:maplibre_gl/maplibre_gl.dart";

import "../models/grave.dart";
import "../services/location_permission_service.dart";

class MapView extends StatefulWidget {
  const MapView({required this.graves, this.onGraveSelected, super.key});

  final IList<Grave> graves;
  final ValueChanged<String>? onGraveSelected;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _gravePinImage = "grave-pin";
  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14);

  MapLibreMapController? _controller;
  var _hasLocationPermission = false;
  var _styleLoaded = false;
  var _didFitCamera = false;
  var _syncGeneration = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_requestLocation());
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graves != widget.graves) unawaited(_syncGraveMarkers());
  }

  @override
  void dispose() {
    _controller?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  Future<void> _requestLocation() async {
    final granted = await const LocationPermissionService().requestPermission();
    if (!mounted) return;
    setState(() => _hasLocationPermission = granted);
  }

  void _onMapCreated(MapLibreMapController controller) {
    _controller = controller;
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  void _onSymbolTapped(Symbol symbol) {
    final graveId = symbol.data?["id"] as String?;
    if (graveId == null) return;

    widget.onGraveSelected?.call(graveId);

    final grave = widget.graves.where((candidate) => candidate.id == graveId).firstOrNull;
    final controller = _controller;
    if (grave == null || controller == null) return;

    unawaited(
      controller.animateCamera(
        CameraUpdate.newLatLng(LatLng(grave.location.latitude, grave.location.longitude)),
      ),
    );
  }

  Future<void> _onStyleLoaded() async {
    final controller = _controller;
    if (controller == null) return;

    final image = await rootBundle.load("assets/images/grave_pin.png");
    if (!mounted) return;
    await controller.addImage(_gravePinImage, image.buffer.asUint8List());
    if (!mounted) return;

    _styleLoaded = true;
    await _syncGraveMarkers();
  }

  Future<void> _syncGraveMarkers() async {
    final controller = _controller;
    if (!_styleLoaded || controller == null) return;

    final generation = ++_syncGeneration;
    final graves = widget.graves.toList();

    await controller.clearSymbols();
    if (!mounted || generation != _syncGeneration) return;
    if (graves.isEmpty) return;

    await controller.addSymbols(
      [
        for (final grave in graves)
          SymbolOptions(
            geometry: LatLng(grave.location.latitude, grave.location.longitude),
            iconImage: _gravePinImage,
            iconAnchor: "bottom",
          ),
      ],
      [
        for (final grave in graves) {"id": grave.id},
      ],
    );
    if (!mounted || generation != _syncGeneration) return;

    await _fitCameraToGraves(controller, graves);
  }

  Future<void> _fitCameraToGraves(MapLibreMapController controller, List<Grave> graves) async {
    if (_didFitCamera || graves.isEmpty) return;
    _didFitCamera = true;

    final first = graves.first.location;
    var minLat = first.latitude;
    var maxLat = first.latitude;
    var minLng = first.longitude;
    var maxLng = first.longitude;

    for (final grave in graves.skip(1)) {
      final lat = grave.location.latitude;
      final lng = grave.location.longitude;
      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }

    final samePoint = (maxLat - minLat).abs() < 1e-8 && (maxLng - minLng).abs() < 1e-8;
    if (graves.length == 1 || samePoint) {
      await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(minLat, minLng), 14));
      return;
    }

    await controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: LatLng(minLat, minLng), northeast: LatLng(maxLat, maxLng)),
        left: 48,
        top: 48,
        right: 48,
        bottom: 48,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapLibreMap(
      initialCameraPosition: _initial,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
      styleString: "https://tiles.openfreemap.org/styles/liberty",
      myLocationEnabled: _hasLocationPermission,
      myLocationTrackingMode: _hasLocationPermission ? MyLocationTrackingMode.tracking : MyLocationTrackingMode.none,
      myLocationRenderMode: _hasLocationPermission ? MyLocationRenderMode.compass : MyLocationRenderMode.normal,
    );
  }
}
