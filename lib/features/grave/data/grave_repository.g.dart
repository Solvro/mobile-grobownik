// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grave_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(graveRepository)
final graveRepositoryProvider = GraveRepositoryProvider._();

final class GraveRepositoryProvider
    extends
        $FunctionalProvider<GraveRepository, GraveRepository, GraveRepository>
    with $Provider<GraveRepository> {
  GraveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'graveRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$graveRepositoryHash();

  @$internal
  @override
  $ProviderElement<GraveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GraveRepository create(Ref ref) {
    return graveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GraveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GraveRepository>(value),
    );
  }
}

String _$graveRepositoryHash() => r'8246324ca1bf46c8caa0a331634042a4dc3428aa';
