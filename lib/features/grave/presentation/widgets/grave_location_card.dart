import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../data/models/grave.dart";

class GraveLocationCard extends StatelessWidget {
  const GraveLocationCard({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cemetery = grave.cemetery;
    final plot = _nonBlank(grave.plot);
    final directions = _nonBlank(grave.directions);
    final location = grave.location;
    final hasDetails = cemetery != null || plot != null || directions != null;

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: context.colorScheme.secondary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cemetery != null)
                _InfoRow(
                  icon: Icons.location_city_outlined,
                  label: l10n.grave_cemetery,
                  value: [cemetery.name, ?_nonBlank(cemetery.address)].join("\n"),
                ),
              if (plot != null) _InfoRow(icon: Icons.grid_view_outlined, label: l10n.grave_plot, value: plot),
              if (directions != null)
                _InfoRow(icon: Icons.directions_walk_outlined, label: l10n.grave_directions, value: directions),
              if (location != null)
                _InfoRow(
                  icon: Icons.pin_drop_outlined,
                  label: l10n.grave_coordinates,
                  value: "${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}",
                  selectable: true,
                ),
              if (!hasDetails)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    l10n.grave_no_location_details,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                ),
              _PrecisionBadge(grave: grave),
              _SourceLink(grave: grave),
            ],
          ),
        ),
      ),
    );
  }
}

String? _nonBlank(String? value) => value == null || value.trim().isEmpty ? null : value.trim();

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value, this.selectable = false});

  final IconData icon;
  final String label;
  final String value;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.colorScheme.primary, semanticLabel: label),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                if (selectable)
                  SelectableText(value, style: context.textTheme.bodyMedium)
                else
                  Text(value, style: context.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrecisionBadge extends StatelessWidget {
  const _PrecisionBadge({required this.grave});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (icon, text, isWarning) = switch ((grave.location, grave.locationPrecision)) {
      (null, _) => (Icons.location_off_outlined, l10n.grave_location_missing, true),
      (_, LocationPrecision.grave) => (Icons.my_location, l10n.grave_location_precision_grave, false),
      (_, LocationPrecision.field) => (Icons.blur_circular, l10n.grave_location_precision_field, true),
      _ => (Icons.help_outline, l10n.grave_location_precision_unknown, true),
    };
    final color = isWarning ? context.colorScheme.onSurfaceVariant : context.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, size: 20, color: color, semanticLabel: text),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: context.textTheme.bodyMedium?.copyWith(color: color)),
        ),
      ],
    );
  }
}

class _SourceLink extends StatelessWidget {
  const _SourceLink({required this.grave});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final source = grave.locationSource;
    final url = Uri.tryParse(_nonBlank(grave.locationSourceUrl) ?? "");
    final hasUrl = url != null && url.hasScheme;
    if (source == null && !hasUrl) return const SizedBox.shrink();

    final sourceName = switch (source) {
      LocationSource.grobonet => l10n.location_source_grobonet,
      LocationSource.mogily => l10n.location_source_mogily,
      LocationSource.cui => l10n.location_source_cui,
      LocationSource.spreadsheet => l10n.location_source_spreadsheet,
      LocationSource.volunteer => l10n.location_source_volunteer,
      LocationSource.other || null => url?.host ?? l10n.location_source_other,
    };

    if (!hasUrl) {
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Text(
          l10n.grave_location_source_label(sourceName),
          style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: TextButton.icon(
        style: TextButton.styleFrom(padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
        icon: Icon(Icons.open_in_new, size: 18, semanticLabel: l10n.action_open_link),
        label: Text(l10n.grave_location_source_open(sourceName)),
        onPressed: () async {
          await HapticFeedback.selectionClick();
          await launchUrl(url, mode: LaunchMode.externalApplication);
        },
      ),
    );
  }
}
