import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../theme/app_theme.dart";

class ProfileIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: context.colorScheme.secondary,
      child: IconButton(
        tooltip: "Profile",
        onPressed: () async {
          await HapticFeedback.selectionClick();
        },
        icon: Icon(Icons.person_outline, color: context.colorScheme.primary, semanticLabel: "Profile"),
      ),
    );
  }
}
