import "package:fast_immutable_collections/fast_immutable_collections.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/l10n/app_localizations.dart";
import "app/observers/app_provider_observer.dart";
import "app/theme/app_theme.dart";
import "common/sync/sync_controller.dart";
import "common/widgets/grave_search_bar.dart";
import "features/cemetery/data/models/cemetery.dart";
import "features/cemetery/data/repositories/cemeteries_repository.dart";
import "features/grave/data/models/grave.dart";
import "features/grave/data/repositories/graves_repository.dart";
import "features/grave/presentation/providers/selected_grave_provider.dart";
import "features/grave/presentation/widgets/grave_draggable_sheet.dart";
import "features/map/presentation/widgets/map_view.dart";
import "features/settings/presentation/providers/theme_mode_provider.dart";
import "features/settings/presentation/widgets/settings_icon_button.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer(observers: [const AppProviderObserver()]);

  // Reading the provider starts the first sync right at app start.
  container.read(syncControllerProvider);

  runApp(UncontrolledProviderScope(container: container, child: const GrobownikApp()));
}

class GrobownikApp extends ConsumerWidget {
  const GrobownikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider).value ?? ThemeMode.dark; //default dark

    return MaterialApp(
      title: "Grobownik",
      debugShowCheckedModeBanner: false,
      theme: const AppTheme().light,
      darkTheme: const AppTheme().dark,
      themeMode: themeMode,
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
    final graves = ref.watch(gravesRepositoryProvider).value ?? const IListConst<Grave>([]);
    final cemeteries = ref.watch(cemeteriesRepositoryProvider).value ?? const IListConst<Cemetery>([]);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapView(
              graves: graves,
              cemeteries: cemeteries,
              onGraveSelected: (graveId) {
                ref.read(selectedGraveIdProvider.notifier).select(graveId);
              },
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: GraveSearchBar()),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: Material(
                      elevation: 4,
                      shape: const CircleBorder(),
                      color: context.colorScheme.surface,
                      child: const SettingsIconButton(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const MyDraggableSheet(),
        ],
      ),
    );
  }
}
