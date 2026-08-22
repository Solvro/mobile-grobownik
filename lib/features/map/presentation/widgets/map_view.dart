import "dart:async";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:maplibre_gl/maplibre_gl.dart";
import "../../../../common/services/location_permission_service.dart";
import "../providers/location_provider.dart";

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
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

  Future<void> _moveToCurrentLocation() async {
    final locationNotifier = ref.read(locationStateProvider.notifier);
    final position = await locationNotifier.getPosition();

    if (position == null || !mounted) return;

    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 16));
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          onMapCreated: _controller.complete,
          styleString: "https://tiles.openfreemap.org/styles/liberty",
          myLocationEnabled: _hasLocationPermission,
          myLocationTrackingMode: _hasLocationPermission
              ? MyLocationTrackingMode.tracking
              : MyLocationTrackingMode.none,
          myLocationRenderMode: _hasLocationPermission ? MyLocationRenderMode.compass : MyLocationRenderMode.normal,
        ),
        Positioned(
          bottom: 30,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => unawaited(_moveToCurrentLocation()),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 4,
            shape: const CircleBorder(),
            child: locationState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                  )
                : const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}
