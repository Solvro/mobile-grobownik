import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../l10n/app_localizations.dart";

class GraveActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: () async {
            await HapticFeedback.selectionClick();
          },
          icon: Icon(Icons.done, semanticLabel: AppLocalizations.of(context)!.mark_as_visited_semantic_label),
          label: Text(AppLocalizations.of(context)!.mark_as_visited),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: () async {
            await HapticFeedback.selectionClick();
          },
          icon: Icon(Icons.navigation, semanticLabel: AppLocalizations.of(context)!.navigate_semantic_label),
          label: Text(AppLocalizations.of(context)!.navigate),
        ),
      ],
    );
  }
}
