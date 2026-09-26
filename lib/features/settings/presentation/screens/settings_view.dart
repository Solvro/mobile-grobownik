import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:package_info_plus/package_info_plus.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../providers/theme_mode_provider.dart";
import "team_info_view.dart";

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final themeMode = ref.watch(themeModeControllerProvider).value ?? ThemeMode.dark;
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _SettingsSectionHeader(title: l10n.settings_appearance),
          SwitchListTile.adaptive(
            secondary: Icon(
              isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              semanticLabel: l10n.settings_dark_mode,
            ),
            title: Text(l10n.settings_dark_mode),
            subtitle: Text(l10n.settings_dark_mode_subtitle),
            value: isDarkMode,
            onChanged: (enabled) async {
              await HapticFeedback.selectionClick();
              await ref.read(themeModeControllerProvider.notifier).setDarkMode(enabled: enabled);
            },
          ),
          const Divider(height: 32),
          _SettingsSectionHeader(title: l10n.settings_about),
          ListTile(
            leading: Icon(Icons.groups_outlined, semanticLabel: l10n.settings_team),
            title: Text(l10n.settings_team),
            subtitle: Text(l10n.settings_team_subtitle),
            trailing: const Icon(Icons.chevron_right, semanticLabel: ""),
            onTap: () async {
              await HapticFeedback.selectionClick();
              if (!context.mounted) return;
              await Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TeamInfoPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.description_outlined, semanticLabel: l10n.settings_licenses),
            title: Text(l10n.settings_licenses),
            subtitle: Text(l10n.settings_licenses_subtitle),
            trailing: const Icon(Icons.chevron_right, semanticLabel: ""),
            onTap: () async {
              await HapticFeedback.selectionClick();
              if (!context.mounted) return;
              final packageInfo = await PackageInfo.fromPlatform();
              if (!context.mounted) return;
              showLicensePage(
                context: context,
                applicationName: "Grobownik",
                applicationVersion: packageInfo.version,
                applicationLegalese: l10n.settings_app_legalese,
              );
            },
          ),
          const _AppVersionTile(),
        ],
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AppVersionTile extends StatelessWidget {
  const _AppVersionTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version;
        final buildNumber = snapshot.data?.buildNumber;
        final label = version == null
            ? l10n.settings_version_unknown
            : l10n.settings_version(version, buildNumber ?? "");

        return ListTile(
          leading: Icon(Icons.info_outline, semanticLabel: l10n.settings_app_info),
          title: Text(l10n.settings_app_info),
          subtitle: Text(label),
        );
      },
    );
  }
}
