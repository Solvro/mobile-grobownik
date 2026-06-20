import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "l10n/app_localizations.dart";
import "theme/app_theme.dart";
import "widgets/bottom_sheet.dart";

void main() {
  runApp(const ProviderScope(child: GrobownikApp()));
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
    return const Scaffold(body: MyDraggableSheet());
  }
}
