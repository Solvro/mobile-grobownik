import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/l10n/app_localizations.dart";
import "app/observers/app_provider_observer.dart";
import "app/theme/app_theme.dart";
import "common/widgets/grave_search_bar.dart";
import "features/grave/presentation/widgets/grave_draggable_sheet.dart";
import "features/map/presentation/widgets/map_view.dart";

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MapView()),
          Positioned(top: 0, left: 0, right: 0, child: SafeArea(bottom: false, child: GraveSearchBar())),
          MyDraggableSheet(),
        ],
      ),
    );
  }
}
