import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "core/providers/app_provider_observer.dart";
import "l10n/app_localizations.dart";
import "repository/graves_repository.dart";
import "theme/app_theme.dart";
import "widgets/bottom_sheet.dart";
import "widgets/map_view.dart";

void main() {
  runApp(const ProviderScope(observers: [AppProviderObserver()], child: GrobownikApp()));
}

class GrobownikApp extends StatelessWidget {
  const GrobownikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grobownik",
      debugShowCheckedModeBanner: false,
      theme: const AppTheme().dark,
      home: const HomeScreen(),

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(map-selection): drive this from the grave tapped on the map.
    final firstGraveId = ref.watch(gravesRepositoryProvider).value?.firstOrNull?.id;

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MapView()),
          if (firstGraveId != null) MyDraggableSheet(graveId: firstGraveId),
        ],
      ),
    );
  }
}
