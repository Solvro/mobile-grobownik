import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/l10n/app_localizations.dart";
import "app/observers/app_provider_observer.dart";
import "app/theme/app_theme.dart";
import "common/sync/sync_controller.dart";
import "common/widgets/map_top_bar.dart";
import "features/grave/presentation/widgets/grave_draggable_sheet.dart";
import "features/map/presentation/widgets/map_view.dart";
import "features/settings/presentation/providers/theme_mode_provider.dart";

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: MapView()),
          Positioned(top: 0, left: 0, right: 0, child: SafeArea(bottom: false, child: MapTopBar())),
          MyDraggableSheet(),
        ],
      ),
    );
  }
}
