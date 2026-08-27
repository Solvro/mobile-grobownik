import "dart:async";
import "dart:math" as math;

import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:geolocator/geolocator.dart";
import "package:maplibre_gl/maplibre_gl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../common/providers/bottom_sheet_extent_provider.dart";
import "../providers/location_provider.dart";

const double _buttonMargin = 16;
import "../../../grave/data/models/grave.dart";

class MapView extends StatefulWidget {
  const MapView({required this.graves, this.onGraveSelected, super.key});

  final IList<Grave> graves;
  final ValueChanged<String>? onGraveSelected;

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  static const _gravePinImage = "grave-pin";
  late final AppLifecycleListener _lifecycle;

  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14);

  MapLibreMapController? _controller;
  var _hasLocationPermission = false;
  var _styleLoaded = false;
  var _didFitCamera = false;
  var _syncGeneration = 0;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refreshAfterSettings);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_controller.future.then((controller) => controller.dispose()));
    super.dispose();
  }

  void _refreshAfterSettings() {
    final access = ref.read(locationStateProvider).value?.access;
    if (access != LocationAccess.deniedForever && access != LocationAccess.serviceDisabled) return;

    unawaited(ref.read(locationStateProvider.notifier).refreshLocation());
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

  Future<void> _moveToCurrentLocation() async {
    final position = await ref.read(locationStateProvider.notifier).getPosition();

    if (!mounted) return;

    if (position == null) {
      _reportUnavailable();

      return;
    }

    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 16));
  }

  void _reportUnavailable() {
    final l10n = AppLocalizations.of(context)!;
    final access = ref.read(locationStateProvider).value?.access;

    final (String message, Future<bool> Function()? openSettings) = switch (access) {
      LocationAccess.serviceDisabled => (l10n.location_service_disabled, Geolocator.openLocationSettings),
      LocationAccess.deniedForever => (l10n.location_permission_blocked, Geolocator.openAppSettings),
      LocationAccess.denied => (l10n.location_permission_denied, null),
      _ => (l10n.location_unavailable, null),
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: openSettings == null
            ? null
            : SnackBarAction(
                label: l10n.open_settings,
                onPressed: () async {
                  await HapticFeedback.selectionClick();
                  await openSettings();
                },
              ),
      ),
    );
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
    final hasPermission = ref.watch(locationStateProvider.select((state) => state.value?.access.isGranted ?? false));

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          onMapCreated: _onMapCreated,
      onStyleLoadedCallback: _onStyleLoaded,
          styleString: "https://tiles.openfreemap.org/styles/liberty",
          myLocationEnabled: hasPermission,
          myLocationTrackingMode: hasPermission ? MyLocationTrackingMode.tracking : MyLocationTrackingMode.none,
          myLocationRenderMode: hasPermission ? MyLocationRenderMode.compass : MyLocationRenderMode.normal,
        ),
        _CurrentLocationButton(onPressed: _moveToCurrentLocation),
      ],
    );
  }
}

class _CurrentLocationButton extends ConsumerWidget {
  const _CurrentLocationButton({required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetExtent = ref.watch(bottomSheetExtentProvider);
    final isLoading = ref.watch(locationStateProvider.select((state) => state.isLoading));

    return Positioned(
      right: _buttonMargin,
      bottom: math.max(sheetExtent, MediaQuery.paddingOf(context).bottom) + _buttonMargin,
      child: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.current_location,
        onPressed: () async {
          await HapticFeedback.selectionClick();
          await onPressed();
        },
        backgroundColor: context.colorScheme.surface,
        foregroundColor: context.colorScheme.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: context.colorScheme.primary),
              )
            : Icon(Icons.my_location, semanticLabel: AppLocalizations.of(context)!.current_location_semantic_label),
      ),
    );
  }
}
