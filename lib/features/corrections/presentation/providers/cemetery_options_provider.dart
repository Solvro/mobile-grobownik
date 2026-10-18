import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../../common/network/directus_client.dart";
import "../../data/grave_corrections_repository.dart";

part "cemetery_options_provider.g.dart";

Duration? _noRetry(int retryCount, Object error) => null;

@Riverpod(retry: _noRetry)
Future<IList<CemeteryOption>> cemeteryOptions(Ref ref) async {
  final options = await ref.watch(directusClientProvider).fetchCemeteryOptions();

  return options.toIList();
}
