import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../common/sync/sync_controller.dart";
import "../../../../common/sync/sync_status.dart";
import "../../data/repositories/graves_repository.dart";
import "../providers/filtered_graves_provider.dart";
import "../providers/selected_grave_provider.dart";
import "grave_list_item.dart";
import "sync_status_header.dart";

class GraveListSheet extends StatelessWidget {
  const GraveListSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [SyncStatusHeader(), _GraveList()]);
  }
}

class _GraveList extends ConsumerWidget {
  const _GraveList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final gravesAsync = ref.watch(gravesRepositoryProvider);
    final entries = ref.watch(filteredGravesWithDistanceProvider);
    final syncStatus = ref.watch(syncControllerProvider);

    // The graves come from the local database. The spinner is only for the
    // very first read of the database.
    if (gravesAsync.isLoading && !gravesAsync.hasValue) {
      return const _CenteredMessage(child: CircularProgressIndicator());
    }

    if (gravesAsync.hasError && !gravesAsync.hasValue) {
      return _CenteredMessage(child: Text(l10n.loading_error));
    }

    if (entries.isEmpty) {
      final databaseIsEmpty = (gravesAsync.value?.length ?? 0) == 0;

      // An empty database is not "no graves found" until a sync has actually
      // finished: before that we are still waiting for the first download
      // (or it failed, e.g. first launch without internet).
      if (databaseIsEmpty) {
        return switch (syncStatus) {
          SyncIdle() || SyncInProgress() => const _CenteredMessage(child: CircularProgressIndicator()),
          SyncFailure() => _CenteredMessage(child: Text(l10n.loading_error)),
          SyncSuccess() => _CenteredMessage(child: Text(l10n.no_graves_found)),
        };
      }

      return _CenteredMessage(child: Text(l10n.no_graves_found));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries)
          GraveListItem(
            grave: entry.grave,
            distanceMeters: entry.distanceMeters,
            onTap: () async {
              await HapticFeedback.lightImpact();
              ref.read(selectedGraveIdProvider.notifier).select(entry.grave.id);
            },
          ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(child: child),
    );
  }
}
