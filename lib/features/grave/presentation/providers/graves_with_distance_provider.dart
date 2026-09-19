import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/providers/user_location_provider.dart";
import "../../../../common/utils/distance.dart";
import "../../data/models/grave.dart";
import "../../data/repositories/graves_repository.dart";

part "graves_with_distance_provider.g.dart";

typedef GraveWithDistance = ({Grave grave, double? distanceMeters});

@riverpod
IList<GraveWithDistance> gravesWithDistance(Ref ref) {
  final graves = ref.watch(gravesRepositoryProvider).asData?.value ?? <Grave>[].lock;
  final position = ref.watch(userLocationProvider).asData?.value;

  final entries =
      <GraveWithDistance>[
        for (final grave in graves) (grave: grave, distanceMeters: distanceToLocation(position, grave.location)),
      ]..sort((a, b) {
        final distanceA = a.distanceMeters;
        final distanceB = b.distanceMeters;
        if (distanceA == null && distanceB == null) return 0;
        if (distanceA == null) return 1;
        if (distanceB == null) return -1;

        return distanceA.compareTo(distanceB);
      });

  return entries.toIList();
}
