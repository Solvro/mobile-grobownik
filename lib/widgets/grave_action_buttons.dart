import "package:flutter/material.dart";
import "package:flutter/services.dart";

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
          icon: const Icon(Icons.done, semanticLabel: "Odznacz grób jako odwiedzony"),
          label: const Text("Odznacz jako odwiedzony"),
        ),
        const SizedBox(width: 12),
        FilledButton.tonalIcon(
          onPressed: () async {
            await HapticFeedback.selectionClick();
          },
          icon: const Icon(Icons.navigation, semanticLabel: "Nawiguj do celu"),
          label: const Text("Nawigacja"),
        ),
      ],
    );
  }
}
