import "package:riverpod_annotation/riverpod_annotation.dart";

part "selected_grave_provider.g.dart";

@riverpod
class SelectedGraveId extends _$SelectedGraveId {
  @override
  String? build() => null;

  void select(String graveId) => state = graveId;

  void clear() => state = null;
}
