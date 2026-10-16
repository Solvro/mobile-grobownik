import "package:flutter/material.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../data/models/grave.dart";

class GraveNotesCard extends StatelessWidget {
  const GraveNotesCard({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final notes = grave.notes?.trim();
    if (notes == null || notes.isEmpty) return const SizedBox.shrink();

    return Card(
      color: context.colorScheme.secondary,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: Icon(
          Icons.sticky_note_2_outlined,
          color: context.colorScheme.primary,
          semanticLabel: AppLocalizations.of(context)!.grave_notes,
        ),
        title: Text(AppLocalizations.of(context)!.grave_notes),
        shape: const Border(),
        collapsedShape: const Border(),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.centerLeft,
        children: [
          SelectableText(
            notes,
            style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
