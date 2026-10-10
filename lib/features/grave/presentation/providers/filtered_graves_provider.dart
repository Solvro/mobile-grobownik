import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/providers/search_query_provider.dart";
import "graves_with_distance_provider.dart";

part "filtered_graves_provider.g.dart";

String _normalizeText(String text) {
  const polishMap = {"ą": "a", "ć": "c", "ę": "e", "ł": "l", "ń": "n", "ó": "o", "ś": "s", "ź": "z", "ż": "z"};

  var normalized = text.toLowerCase();
  polishMap.forEach((polishChar, latinChar) {
    normalized = normalized.replaceAll(polishChar, latinChar);
  });

  return normalized.replaceAll(RegExp(r"\s+"), " ").trim();
}

@riverpod
IList<GraveWithDistance> filteredGravesWithDistance(Ref ref) {
  final entries = ref.watch(gravesWithDistanceProvider);
  final rawQuery = ref.watch(searchQueryProvider);

  final normalizedQuery = _normalizeText(rawQuery);
  if (normalizedQuery.isEmpty) return entries;

  final queryWords = normalizedQuery.split(" ").where((word) => word.isNotEmpty).toList();

  if (queryWords.isEmpty) return entries;

  return entries.where((entry) {
    final grave = entry.grave;

    final fullName = "${grave.firstName} ${grave.lastName}";
    final normalizedTarget = _normalizeText(fullName);

    return queryWords.every(normalizedTarget.contains);
  }).toIList();
}
