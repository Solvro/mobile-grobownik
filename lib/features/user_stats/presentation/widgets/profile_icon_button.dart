import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import 'package:mobile_grobownik/features/auth/data/auth_service.dart';
import 'package:mobile_grobownik/features/auth/presentation/screens/login_view.dart';
import 'package:mobile_grobownik/features/user_stats/presentation/screens/user_stats_view.dart';

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
