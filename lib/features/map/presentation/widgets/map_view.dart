import "dart:async";
import "dart:math" as math;

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

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  final _controller = Completer<MapLibreMapController>();
  late final AppLifecycleListener _lifecycle;

  static const _initial = CameraPosition(target: LatLng(51.1079, 17.0385), zoom: 14);

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

  @override
  Widget build(BuildContext context) {
    final hasPermission = ref.watch(locationStateProvider.select((state) => state.value?.access.isGranted ?? false));

    return Stack(
      children: [
        MapLibreMap(
          initialCameraPosition: _initial,
          onMapCreated: _controller.complete,
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
