import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/network/directus_client.dart";
import "../../../auth/presentation/providers/auth_controller.dart";
import "../../data/models/visit_record.dart";
import "../../data/repositories/grave_visits_repository.dart";

part "grave_visits_provider.g.dart";

Duration? _noRetry(int retryCount, Object error) => null;

@Riverpod(retry: _noRetry)
Future<IList<VisitRecord>?> graveVisits(Ref ref, String graveId) async {
  final status = ref.watch(authControllerProvider);
  if (status != AuthStatus.loggedIn) return null;

  final visits = await ref.watch(directusClientProvider).fetchMyGraveVisits(graveId);

  return visits.toIList();
}
