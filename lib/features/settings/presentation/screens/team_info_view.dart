import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:url_launcher/url_launcher.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../data/team_members.dart";

class TeamInfoPage extends StatelessWidget {
  const TeamInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings_team)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: context.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.school_outlined,
                      size: 36,
                      color: context.colorScheme.onPrimaryContainer,
                      semanticLabel: TeamMembers.clubName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    TeamMembers.clubName,
                    style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    TeamMembers.clubDescription,
                    style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settings_team_members,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (final member in TeamMembers.members)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colorScheme.secondaryContainer,
                  child: Text(
                    member.name.characters.first,
                    style: TextStyle(color: context.colorScheme.onSecondaryContainer),
                  ),
                ),
                title: Text(member.name),
                subtitle: Text(member.role),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            l10n.settings_team_links,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.language, semanticLabel: l10n.settings_team_website),
            title: Text(l10n.settings_team_website),
            subtitle: const Text(TeamMembers.websiteUrl),
            trailing: const Icon(Icons.open_in_new, semanticLabel: ""),
            onTap: () async {
              await HapticFeedback.selectionClick();
              await _openUrl(TeamMembers.websiteUrl);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.code, semanticLabel: l10n.settings_team_github),
            title: Text(l10n.settings_team_github),
            subtitle: const Text(TeamMembers.githubUrl),
            trailing: const Icon(Icons.open_in_new, semanticLabel: ""),
            onTap: () async {
              await HapticFeedback.selectionClick();
              await _openUrl(TeamMembers.githubUrl);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
