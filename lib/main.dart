import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "app/l10n/app_localizations.dart";
import "app/observers/app_provider_observer.dart";
import "app/theme/app_theme.dart";
import "common/widgets/grave_search_bar.dart";
import "features/grave/presentation/widgets/grave_draggable_sheet.dart";
import "features/map/presentation/widgets/map_view.dart";
import "features/settings/presentation/providers/theme_mode_provider.dart";
import "features/settings/presentation/widgets/settings_icon_button.dart";

void main() {
  runApp(const ProviderScope(observers: [AppProviderObserver()], child: GrobownikApp()));
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
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MapView()),
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
