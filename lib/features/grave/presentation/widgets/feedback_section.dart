import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../auth/presentation/require_login.dart";
import "../../../corrections/data/grave_correction.dart";
import "../../../corrections/presentation/screens/grave_correction_screen.dart";
import "../../data/models/grave.dart";

class FeedbackSection extends ConsumerWidget {
  const FeedbackSection({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> open(CorrectionKind kind) async {
      if (!await requireLogin(context, ref) || !context.mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => GraveCorrectionScreen(grave: grave, kind: kind),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      children: [
        TextButton.icon(
          onPressed: () async {
            await HapticFeedback.selectionClick();
            if (context.mounted) await open(CorrectionKind.correction);
          },
          icon: Icon(Icons.edit_outlined, semanticLabel: l10n.suggest_fix_semantic_label),
          label: Text(l10n.suggest_fix),
        ),
        TextButton.icon(
          onPressed: () async {
            await HapticFeedback.selectionClick();
            if (context.mounted) await open(CorrectionKind.photo);
          },
          icon: Icon(Icons.add_a_photo_outlined, semanticLabel: l10n.add_photos),
          label: Text(l10n.add_photos),
        ),
      ],
    );
  }
}
