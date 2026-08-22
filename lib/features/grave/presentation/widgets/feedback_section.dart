import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../../../app/l10n/app_localizations.dart";

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          await HapticFeedback.selectionClick();
        },
        icon: Icon(Icons.edit_outlined, semanticLabel: AppLocalizations.of(context)!.suggest_fix_semantic_label),
        label: Text(AppLocalizations.of(context)!.suggest_fix),
      ),
    );
  }
}
