import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Импортируем модель Grave через package-путь
import 'package:mobile_grobownik/models/grave.dart';
import 'package:mobile_grobownik/features/grave/data/grave_repository.dart';

part 'grave_details_provider.g.dart';

@riverpod
class GraveDetails extends _$GraveDetails {
  @override
  FutureOr<Grave> build(String graveId) async {
    final repository = ref.watch(graveRepositoryProvider);
    return repository.getGraveDetails(graveId);
  }

  Future<void> visitGrave(String graveId) async {
    final repository = ref.read(graveRepositoryProvider);
    try {
      await repository.markGraveAsVisited(graveId);
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}