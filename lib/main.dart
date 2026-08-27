import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "core/providers/app_provider_observer.dart";
import "l10n/app_localizations.dart";
import "models/grave.dart";
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedGraveId;

  @override
  Widget build(BuildContext context) {
    final graves = ref.watch(gravesRepositoryProvider).value ?? const IListConst<Grave>([]);
    final selectedGraveId = _selectedGraveId ?? graves.firstOrNull?.id;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapView(
              graves: graves,
              onGraveSelected: (graveId) => setState(() => _selectedGraveId = graveId),
            ),
          ),
          if (selectedGraveId != null) MyDraggableSheet(graveId: selectedGraveId),
        ],
      ),
    );
  }
}
