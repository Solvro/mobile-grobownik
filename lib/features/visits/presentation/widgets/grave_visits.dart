import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../auth/presentation/providers/auth_controller.dart";
import "../../../auth/presentation/screens/login_view.dart";
import "../providers/grave_visits_provider.dart";

class GraveVisitsSummary extends ConsumerWidget {
  const GraveVisitsSummary({required this.graveId, super.key});

  final String graveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visits = ref.watch(graveVisitsProvider(graveId)).value;
    if (visits == null) return const SizedBox.shrink();

    final lastVisit = visits.firstOrNull?.visitedAt;
    final text = lastVisit == null
        ? l10n.grave_visits_none
        : l10n.grave_visits_summary(visits.length.toString(), DateFormat("dd.MM.yyyy").format(lastVisit.toLocal()));

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 18,
            color: context.colorScheme.onSurfaceVariant,
            semanticLabel: l10n.grave_tab_my_visits,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class GraveVisitsHistory extends ConsumerWidget {
  const GraveVisitsHistory({required this.graveId, super.key});

  final String graveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final authStatus = ref.watch(authControllerProvider);
    final visitsState = ref.watch(graveVisitsProvider(graveId));
    final dateFormat = DateFormat("dd.MM.yyyy, HH:mm");

    final Widget content;
    if (authStatus == AuthStatus.loggedOut || authStatus == AuthStatus.failed) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.grave_visits_login_prompt, style: context.textTheme.bodyMedium),
          const SizedBox(height: 8),
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () async {
              await HapticFeedback.selectionClick();
              if (!context.mounted) return;
              await Navigator.push(context, MaterialPageRoute<void>(builder: (context) => const LoginScreen()));
            },
            child: Text(l10n.login),
          ),
        ],
      );
    } else {
      content = switch (visitsState) {
        AsyncData(value: null) => Text(l10n.grave_visits_unavailable, style: context.textTheme.bodyMedium),
        AsyncData(:final value?) when value.isEmpty => Text(
          l10n.grave_visits_none,
          style: context.textTheme.bodyMedium,
        ),
        AsyncData(:final value?) => Column(
          children: [
            for (final visit in value)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.check_circle_outline,
                  color: context.colorScheme.primary,
                  semanticLabel: l10n.visit_marked,
                ),
                title: Text(
                  visit.visitedAt == null ? l10n.visit_date_unknown : dateFormat.format(visit.visitedAt!.toLocal()),
                ),
              ),
          ],
        ),
        AsyncError() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.grave_visits_error, style: context.textTheme.bodyMedium),
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () async {
                await HapticFeedback.selectionClick();
                ref.invalidate(graveVisitsProvider(graveId));
              },
              child: Text(l10n.action_retry),
            ),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator()),
      };
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: context.colorScheme.secondary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.all(16), child: content),
      ),
    );
  }
}
