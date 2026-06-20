import "package:flutter/material.dart";
import "package:flutter/services.dart";

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () async {
          await HapticFeedback.selectionClick();
        },
        icon: const Icon(Icons.edit_outlined, semanticLabel: "Zgłoś poprawkę dotyczącą informacji o grobie"),
        label: const Text("Zgłoś poprawkę"),
      ),
    );
  }
}
