import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/providers/search_query_provider.dart";
import "graves_with_distance_provider.dart";

part "filtered_graves_provider.g.dart";

@riverpod
IList<GraveWithDistance> filteredGravesWithDistance(Ref ref) {
  final entries = ref.watch(gravesWithDistanceProvider);
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) return entries;

  return entries.where((entry) {
    final grave = entry.grave;
    final fullName = "${grave.firstName} ${grave.lastName}".toLowerCase();

    return fullName.contains(query);
  }).toIList();
}
