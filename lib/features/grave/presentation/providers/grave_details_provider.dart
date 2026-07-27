import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../models/grave.dart";
import "../../../../repository/graves_repository.dart";

part "grave_details_provider.g.dart";

@riverpod
class GraveDetails extends _$GraveDetails {
  @override
  Future<Grave> build(String graveId) => ref.watch(graveRepositoryProvider(graveId).future);
}
