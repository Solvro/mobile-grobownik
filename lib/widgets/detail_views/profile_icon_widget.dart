import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../l10n/app_localizations.dart";
import "../../services/auth_service.dart";
import "../../theme/app_theme.dart";
import "../login_view.dart";
import "../user_stats_view.dart";

class ProfileIconWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: context.colorScheme.secondary,
      child: IconButton(
        tooltip: AppLocalizations.of(context)!.profile,
        onPressed: () async {
          await HapticFeedback.selectionClick();

          final loggedIn = await AuthService.isLoggedIn();
          if (!context.mounted) return;

          if (loggedIn) {
            await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const UserStatsPage()));
          } else {
            await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const LoginScreen()));
          }
        },
        icon: Icon(
          Icons.person_outline,
          color: context.colorScheme.primary,
          semanticLabel: AppLocalizations.of(context)!.profile_semantic_label,
        ),
      ),
    );
  }
}
