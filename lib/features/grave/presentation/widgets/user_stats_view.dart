import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../features/user_stats/presentation/providers/user_stats_provider.dart";
import "../services/auth_service.dart";
import "login_view.dart";

class UserStatsPage extends ConsumerWidget {
  const UserStatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & History"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, semanticLabel: "Log out of your account"),
            tooltip: "Log out",
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
                const Icon(Icons.error_outline, color: Colors.red, size: 48, semanticLabel: "Error"),
                const SizedBox(height: 16),
                Text("Error loading stats:\n$err", textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await HapticFeedback.selectionClick();
                    ref.invalidate(userStatsControllerProvider);
                  },
                  child: const Text("Retry"),
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
                            semanticLabel: "Location city",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Graves Visited", style: Theme.of(context).textTheme.bodyMedium),
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
                  "Visit History",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                if (stats.visitHistory.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: Text("No visits recorded yet.")),
                  )
                else
                  ...stats.visitHistory.map((visit) {
                    final dateStr = visit.visitedAt != null
                        ? "${visit.visitedAt!.day}.${visit.visitedAt!.month}.${visit.visitedAt!.year}"
                        : "Unknown date";

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.place, semanticLabel: "Place"),
                        ),
                        title: Text("Grave ID: ${visit.graveId}"),
                        subtitle: Text(
                          "Location: ${visit.location.latitude.toStringAsFixed(4)}, ${visit.location.longitude.toStringAsFixed(4)}",
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
