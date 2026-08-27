import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/l10n/app_localizations.dart";
import "app/observers/app_provider_observer.dart";
import "app/theme/app_theme.dart";
import "features/grave/data/repositories/graves_repository.dart";
import "features/grave/presentation/widgets/grave_draggable_sheet.dart";
import "features/map/presentation/widgets/map_view.dart";
import "features/grave/data/models/grave.dart";

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
