import "dart:async";

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:maplibre_gl/maplibre_gl.dart";

import "../../../../app/theme/colors.dart";
import "../../../../common/services/location_permission_service.dart";
import "../../../cemetery/data/models/cemetery.dart";
import "../../../grave/data/models/grave.dart";

class MapView extends StatefulWidget {
  const MapView({required this.graves, required this.cemeteries, this.onGraveSelected, super.key});

  final IList<Grave> graves;
  final IList<Cemetery> cemeteries;
  final ValueChanged<String>? onGraveSelected;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _gravePinImage = "grave-pin";
  static const _cemeteryOutlineLayerId = "landuse-cemetery-outline";
  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14);

  MapLibreMapController? _controller;
  var _hasLocationPermission = false;
  var _styleLoaded = false;
  var _hasLayout = false;
  var _didFitCamera = false;
  var _didAddCemeteryFills = false;
  var _syncGeneration = 0;
  var _cemeterySyncGeneration = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_requestLocation());
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graves != widget.graves) unawaited(_syncGraveMarkers());
    if (oldWidget.cemeteries != widget.cemeteries) unawaited(_syncCemeteryBorders());
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
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(grave.location.latitude, grave.location.longitude))),
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
    await _styleBasemapCemeteries();
    if (!mounted) return;
    await _syncGraveMarkers();
    if (!mounted) return;
    await _syncCemeteryBorders();
  }

  Future<void> _styleBasemapCemeteries() async {
    final controller = _controller;
    if (controller == null) return;

    try {
      final layerIds = await controller.getLayerIds();
      for (final layerId in layerIds.whereType<String>()) {
        if (!layerId.toLowerCase().contains("cemetery")) continue;
        try {
          await controller.setLayerProperties(
            layerId,
            FillLayerProperties(
              fillColor: ColorsConsts.darkNavyBlue.hexString,
              fillOpacity: 0.75,
              fillOutlineColor: ColorsConsts.goldenYellow.hexString,
            ),
          );
        } on Object {
          continue;
        }
      }

      await controller.addLineLayer(
        "openmaptiles",
        _cemeteryOutlineLayerId,
        LineLayerProperties(lineColor: ColorsConsts.goldenYellow.hexString, lineWidth: 2, lineJoin: "round"),
        sourceLayer: "landuse",
        filter: [
          "==",
          ["get", "class"],
          "cemetery",
        ],
        enableInteraction: false,
      );
    } on Object {
      return;
    }
  }

  Future<void> _syncCemeteryBorders() async {
    final controller = _controller;
    if (!_styleLoaded || controller == null) return;

    final generation = ++_cemeterySyncGeneration;
    final fills = _cemeteryFillOptions(widget.cemeteries);
    final outlines = _cemeteryLineOptions(widget.cemeteries);

    try {
      if (fills.isEmpty && outlines.isEmpty) {
        if (!_didAddCemeteryFills) return;
        await controller.clearFills();
        await controller.clearLines();
        _didAddCemeteryFills = false;
        return;
      }

      await controller.clearFills();
      await controller.clearLines();
      if (!mounted || generation != _cemeterySyncGeneration) return;

      if (fills.isNotEmpty) await controller.addFills(fills);
      if (!mounted || generation != _cemeterySyncGeneration) return;
      if (outlines.isNotEmpty) await controller.addLines(outlines);
      _didAddCemeteryFills = true;
    } on Object {
      return;
    }
  }

  List<FillOptions> _cemeteryFillOptions(IList<Cemetery> cemeteries) {
    final options = <FillOptions>[];

    for (final cemetery in cemeteries) {
      for (final polygon in cemetery.boundary.polygons) {
        final rings = <List<LatLng>>[];
        for (final ring in polygon) {
          final points = [
            for (final point in ring)
              if (point.length >= 2) LatLng(point[1], point[0]),
          ];
          if (points.length >= 3) rings.add(points);
        }
        if (rings.isEmpty) continue;

        options.add(
          FillOptions(
            geometry: rings,
            fillColor: ColorsConsts.darkNavyBlue.hexString,
            fillOpacity: 0.75,
            fillOutlineColor: ColorsConsts.goldenYellow.hexString,
          ),
        );
      }
    }

    return options;
  }

  List<LineOptions> _cemeteryLineOptions(IList<Cemetery> cemeteries) {
    final options = <LineOptions>[];

    for (final cemetery in cemeteries) {
      for (final polygon in cemetery.boundary.polygons) {
        if (polygon.isEmpty) continue;
        final points = [
          for (final point in polygon.first)
            if (point.length >= 2) LatLng(point[1], point[0]),
        ];
        if (points.length < 2) continue;

        options.add(
          LineOptions(
            geometry: points,
            lineColor: ColorsConsts.goldenYellow.hexString,
            lineWidth: 2.5,
            lineJoin: "round",
          ),
        );
      }
    }

    return options;
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasSize = constraints.maxWidth >= 1 && constraints.maxHeight >= 1;
        if (hasSize && !_hasLayout) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hasLayout = true);
          });
        }
        if (!_hasLayout) return const SizedBox.expand();

        return MapLibreMap(
          initialCameraPosition: _initial,
          onMapCreated: _onMapCreated,
          onStyleLoadedCallback: _onStyleLoaded,
          styleString: "https://tiles.openfreemap.org/styles/liberty",
          myLocationEnabled: _hasLocationPermission,
          myLocationTrackingMode: _hasLocationPermission
              ? MyLocationTrackingMode.tracking
              : MyLocationTrackingMode.none,
          myLocationRenderMode: _hasLocationPermission ? MyLocationRenderMode.compass : MyLocationRenderMode.normal,
        );
      },
    );
  }
}
