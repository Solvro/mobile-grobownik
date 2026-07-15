// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grave_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GraveDetails)
final graveDetailsProvider = GraveDetailsFamily._();

final class GraveDetailsProvider
    extends $AsyncNotifierProvider<GraveDetails, Grave> {
  GraveDetailsProvider._({
    required GraveDetailsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'graveDetailsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$graveDetailsHash();

  @override
  String toString() {
    return r'graveDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GraveDetails create() => GraveDetails();

  @override
  bool operator ==(Object other) {
    return other is GraveDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$graveDetailsHash() => r'5e05dbd40540fdd2d5785f41605c877e66b0fc5f';

final class GraveDetailsFamily extends $Family
    with
        $ClassFamilyOverride<
          GraveDetails,
          AsyncValue<Grave>,
          Grave,
          FutureOr<Grave>,
          String
        > {
  GraveDetailsFamily._()
    : super(
        retry: null,
        name: r'graveDetailsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GraveDetailsProvider call(String graveId) =>
      GraveDetailsProvider._(argument: graveId, from: this);

  @override
  String toString() => r'graveDetailsProvider';
}

abstract class _$GraveDetails extends $AsyncNotifier<Grave> {
  late final _$args = ref.$arg as String;
  String get graveId => _$args;

  FutureOr<Grave> build(String graveId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Grave>, Grave>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Grave>, Grave>,
              AsyncValue<Grave>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
