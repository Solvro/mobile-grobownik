import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/models/grave.dart";
import "../../data/repositories/graves_repository.dart";

part "grave_details_provider.g.dart";

@riverpod
class GraveDetails extends _$GraveDetails {
  @override
  Future<Grave> build(String graveId) => ref.watch(graveRepositoryProvider(graveId).future);
}
