import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../../app/theme/colors.dart";
import "../../../auth/presentation/providers/auth_controller.dart";
import "../../../auth/presentation/screens/login_view.dart";
import "../screens/user_stats_view.dart";

class ProfileIconButton extends ConsumerWidget {
  const ProfileIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final status = ref.watch(authControllerProvider);

    final statusLabel = switch (status) {
      AuthStatus.loggedOut => null,
      AuthStatus.inProgress => l10n.auth_status_in_progress,
      AuthStatus.loggedIn => l10n.auth_status_logged_in,
      AuthStatus.failed => l10n.auth_status_failed,
      AuthStatus.offline => l10n.auth_status_offline,
    };

    return IconButton(
      tooltip: statusLabel == null ? l10n.profile : "${l10n.profile} – $statusLabel",
      onPressed: () async {
        await HapticFeedback.selectionClick();
        if (!context.mounted) return;

        final needsLogin = status == AuthStatus.loggedOut || status == AuthStatus.failed;
        await Navigator.push(
          context,
          MaterialPageRoute<void>(builder: (context) => needsLogin ? const LoginScreen() : const UserStatsPage()),
        );
      },
      icon: SizedBox.square(
        dimension: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.person_outline,
              color: context.colorScheme.primary,
              semanticLabel: [l10n.profile_semantic_label, ?statusLabel].join(", "),
            ),
            if (status == AuthStatus.inProgress)
              Positioned.fill(child: CircularProgressIndicator(strokeWidth: 2.5, color: context.colorScheme.primary)),
            if (_badgeFor(status) case (final icon, final color))
              Positioned(
                right: 0,
                bottom: 0,
                child: _StatusBadge(icon: icon, color: color, label: statusLabel ?? l10n.profile),
              ),
          ],
        ),
      ),
    );
  }

  static (IconData, Color)? _badgeFor(AuthStatus status) => switch (status) {
    AuthStatus.loggedIn => (Icons.check_circle, ColorsConsts.emeraldGreen),
    AuthStatus.failed => (Icons.error, ColorsConsts.goldenYellow),
    AuthStatus.offline => (Icons.cloud_off, ColorsConsts.slateGray),
    AuthStatus.loggedOut || AuthStatus.inProgress => null,
  };
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.icon, required this.color, required this.label});

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colorScheme.surface, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Icon(icon, size: 16, color: color, semanticLabel: label),
      ),
    );
  }
}
