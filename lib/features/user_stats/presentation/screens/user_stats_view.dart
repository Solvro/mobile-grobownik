import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../../auth/data/auth_service.dart";
import "../../../auth/presentation/screens/login_view.dart";
import "../../../settings/presentation/widgets/settings_icon_button.dart";
import "../providers/user_stats_provider.dart";

class UserStatsPage extends ConsumerWidget {
  const UserStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
        actions: [
          const SettingsIconButton(),
          IconButton(
            icon: Icon(Icons.logout, semanticLabel: AppLocalizations.of(context)!.logout),
            tooltip: AppLocalizations.of(context)!.logout,
            onPressed: () async {
              await HapticFeedback.selectionClick();

              await AuthService.logout();
              if (!context.mounted) return;

              await Navigator.pushReplacement(
                context,
                MaterialPageRoute<void>(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: context.colorScheme.error,
                  size: 48,
                  semanticLabel: AppLocalizations.of(context)!.error_title,
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.stats_loading_error(err.toString()), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await HapticFeedback.selectionClick();
                    ref.invalidate(userStatsControllerProvider);
                  },
                  child: Text(AppLocalizations.of(context)!.action_retry),
                ),
              ],
            ),
          ),
        ),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(userStatsControllerProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_city,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            size: 32,
                            semanticLabel: AppLocalizations.of(context)!.location_city,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.stats_total_graves_visited,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              "${stats.visitedGravesCount}",
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  AppLocalizations.of(context)!.visit_history,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (stats.visitHistory.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text(AppLocalizations.of(context)!.visits_empty)),
                  )
                else
                  ...stats.visitHistory.map((visit) {
                    final dateStr = visit.visitedAt != null
                        ? DateFormat.yMd(Localizations.localeOf(context).toString()).format(visit.visitedAt!)
                        : AppLocalizations.of(context)!.visit_date_unknown;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Icon(Icons.place, semanticLabel: AppLocalizations.of(context)!.location_place),
                        ),
                        title: Text(AppLocalizations.of(context)!.visit_grave_id(visit.graveId)),
                        subtitle: Text(
                          AppLocalizations.of(context)!.visit_location_coords(
                            visit.location.latitude.toStringAsFixed(4),
                            visit.location.longitude.toStringAsFixed(4),
                          ),
                        ),
                        trailing: Text(dateStr, style: Theme.of(context).textTheme.bodySmall),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
