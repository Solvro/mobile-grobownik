import "dart:async";
import "dart:convert";
import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:maplibre_gl/maplibre_gl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../app/theme/colors.dart";
import "../../../../common/models/location.dart";
import "../../../map/presentation/providers/location_provider.dart";

const _regularStyle = "https://tiles.openfreemap.org/styles/liberty";

const _orthophotoTiles =
    "https://mapy.geoportal.gov.pl/wss/service/PZGIK/ORTO/WMTS/StandardResolution"
    "?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=ORTOFOTOMAPA&STYLE=default"
    "&FORMAT=image/jpeg&TILEMATRIXSET=EPSG:3857&TILEMATRIX=EPSG:3857:{z}&TILEROW={y}&TILECOL={x}";

final _satelliteStyle = jsonEncode({
  "version": 8,
  "sources": {
    "ortho": {
      "type": "raster",
      "tiles": [_orthophotoTiles],
      "tileSize": 256,
      "maxzoom": 19,
      "attribution": "Ortofotomapa © GUGiK",
    },
  },
  "layers": [
    {"id": "ortho", "type": "raster", "source": "ortho"},
  ],
});

const _wroclaw = LatLng(51.1079, 17.0385);

const _currentFill = ColorsConsts.lightSteelBlue;
const _currentStroke = ColorsConsts.midnightNavy;

String _hex(Color color) => "#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, "0")}";
const _pinSize = 48.0;

class LocationPickerScreen extends HookConsumerWidget {
  const LocationPickerScreen({this.current, this.initial, super.key});

  final Location? current;

  final Location? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final satellite = useState(true);
    final showMe = useState(true);
    final controller = useRef<MapLibreMapController?>(null);

    final start = initial ?? current;
    final camera = useRef(
      CameraPosition(
        target: start == null ? _wroclaw : LatLng(start.latitude, start.longitude),
        zoom: start == null ? 13 : 19,
      ),
    );

    final hasPermission = ref.watch(locationStateProvider.select((state) => state.value?.access.isGranted ?? false));

    Future<void> addCurrentMarker() async {
      final mapController = controller.value;
      if (current == null || mapController == null) return;

      await mapController.addCircle(
        CircleOptions(
          geometry: LatLng(current!.latitude, current!.longitude),
          circleRadius: 7,
          circleColor: _hex(_currentFill),
          circleStrokeColor: _hex(_currentStroke),
          circleStrokeWidth: 2,
        ),
      );
    }

    Future<void> goToMe() async {
      final position = await ref.read(locationStateProvider.notifier).getPosition();
      final mapController = controller.value;
      if (position == null || mapController == null) return;

      showMe.value = true;
      await mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 19));
    }

    final bottomInset = 88 + MediaQuery.paddingOf(context).bottom;

    void confirm() {
      final target = controller.value?.cameraPosition?.target ?? camera.value.target;
      Navigator.pop(context, Location(type: "Point", coordinates: [target.longitude, target.latitude]));
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.location_picker_title)),
      body: Stack(
        children: [
          MapLibreMap(
            key: ValueKey(satellite.value),
            styleString: satellite.value ? _satelliteStyle : _regularStyle,
            initialCameraPosition: camera.value,
            trackCameraPosition: true,
            onMapCreated: (mapController) => controller.value = mapController,
            onStyleLoadedCallback: () => unawaited(addCurrentMarker()),
            onCameraIdle: () {
              final position = controller.value?.cameraPosition;
              if (position != null) camera.value = position;
            },
            myLocationEnabled: hasPermission && showMe.value,
            compassEnabled: false,
            attributionButtonPosition: AttributionButtonPosition.bottomLeft,
            attributionButtonMargins: math.Point(12, bottomInset + 8),
          ),
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: _pinSize),
                child: Icon(
                  Icons.location_on,
                  size: _pinSize,
                  color: context.colorScheme.error,
                  shadows: const [Shadow(blurRadius: 6)],
                  semanticLabel: l10n.location_picker_pin,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              color: context.colorScheme.surface.withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.location_picker_hint, style: context.textTheme.bodyMedium),
                    if (current != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _currentFill,
                              shape: BoxShape.circle,
                              border: Border.all(color: _currentStroke, width: 2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.location_picker_current, style: context.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: bottomInset + 8,
            child: Column(
              children: [
                _MapButton(
                  tooltip: satellite.value ? l10n.location_picker_map : l10n.location_picker_satellite,
                  icon: satellite.value ? Icons.map_outlined : Icons.satellite_alt_outlined,
                  action: () async => satellite.value = !satellite.value,
                ),
                if (hasPermission) ...[
                  const SizedBox(height: 12),
                  _MapButton(
                    tooltip: showMe.value ? l10n.location_picker_hide_me : l10n.location_picker_show_me,
                    icon: showMe.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    action: () async => showMe.value = !showMe.value,
                  ),
                ],
                const SizedBox(height: 12),
                _MapButton(tooltip: l10n.location_picker_go_to_me, icon: Icons.my_location, action: goToMe),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.paddingOf(context).bottom,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              onPressed: () async {
                await HapticFeedback.selectionClick();
                if (context.mounted) confirm();
              },
              icon: Icon(Icons.check, semanticLabel: l10n.location_picker_confirm),
              label: Text(l10n.location_picker_confirm),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.tooltip, required this.icon, required this.action});

  final String tooltip;
  final IconData icon;
  final Future<void> Function() action;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: null,
      tooltip: tooltip,
      backgroundColor: context.colorScheme.surface,
      foregroundColor: context.colorScheme.primary,
      shape: const CircleBorder(),
      onPressed: () async {
        await HapticFeedback.selectionClick();
        await action();
      },
      child: Icon(icon, semanticLabel: tooltip),
    );
  }
}
