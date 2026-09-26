import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../screens/settings_view.dart";

class SettingsIconButton extends StatelessWidget {
  const SettingsIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return IconButton(
      tooltip: l10n.settings,
      onPressed: () async {
        await HapticFeedback.selectionClick();
        if (!context.mounted) return;
        await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
      },
      icon: Icon(
        Icons.settings_outlined,
        color: context.colorScheme.primary,
        semanticLabel: l10n.settings_semantic_label,
      ),
    );
  }
}
