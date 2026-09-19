import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../data/repositories/graves_repository.dart";
import "../providers/filtered_graves_provider.dart";
import "../providers/selected_grave_provider.dart";
import "grave_list_item.dart";

class GraveListSheet extends ConsumerWidget {
  const GraveListSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gravesAsync = ref.watch(gravesRepositoryProvider);
    final entries = ref.watch(filteredGravesWithDistanceProvider);

    // Spinner only while graves have never been fetched even once (e.g. cold
    // app start). Any later background refresh keeps the already-known list
    // on screen instead of flashing a loading indicator.
    if (gravesAsync.isLoading && !gravesAsync.hasValue) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Likewise, only show the error state if we have never managed to load
    // any graves at all - a transient refresh failure shouldn't wipe out a
    // list the user is already looking at.
    if (gravesAsync.hasError && !gravesAsync.hasValue) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(AppLocalizations.of(context)!.loading_error)),
      );
    }

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text(AppLocalizations.of(context)!.no_graves_found)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in entries)
          GraveListItem(
            grave: entry.grave,
            distanceMeters: entry.distanceMeters,
            onTap: () => ref.read(selectedGraveIdProvider.notifier).select(entry.grave.id),
          ),
      ],
    );
  }
}
