import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

base class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    if (!kDebugMode) return;
    debugPrint('--- [Riverpod Added] ---');
    debugPrint('Provider: ${context.provider.name ?? context.provider.runtimeType}');
    debugPrint('Initial Value: $value');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (!kDebugMode) return;
    debugPrint('--- [Riverpod Updated] ---');
    debugPrint('Provider: ${context.provider.name ?? context.provider.runtimeType}');
    debugPrint('Previous Value: $previousValue');
    debugPrint('New Value: $newValue');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    if (!kDebugMode) return;
    debugPrint('--- [Riverpod Disposed] ---');
    debugPrint('Provider: ${context.provider.name ?? context.provider.runtimeType}');
  }
}