import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../../../app/theme/app_theme.dart";
import "../../data/models/grave.dart";

class BiographyCard extends StatelessWidget {
  const BiographyCard({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final biography = _nonBlank(grave.biography);
    final education = _nonBlank(grave.education);
    final mutedStyle = context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant);

    final sections = <Widget>[
      if (biography != null) Text(biography, style: context.textTheme.bodyMedium),
      if (education != null) _Section(title: l10n.grave_education, child: Text(education)),
      if (grave.subjects.isNotEmpty)
        _Section(
          title: l10n.grave_subjects,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final subject in grave.subjects)
                Chip(label: Text([subject.name, ?_nonBlank(subject.faculty)].join(" · "))),
            ],
          ),
        ),
      if (grave.achievements.isNotEmpty)
        _Section(
          title: l10n.grave_achievements,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final achievement in grave.achievements)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.emoji_events_outlined,
                        size: 20,
                        color: context.colorScheme.primary,
                        semanticLabel: l10n.grave_achievements,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              [
                                achievement.name,
                                if (achievement.date case final date?) DateFormat("dd.MM.yyyy").format(date),
                              ].join(" · "),
                              style: context.textTheme.bodyMedium,
                            ),
                            if (_nonBlank(achievement.description) case final description?)
                              Text(description, style: mutedStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
    ];

    return SizedBox(
      width: double.infinity,
      child: Card(
        color: context.colorScheme.secondary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.grave_biography_title, style: context.textTheme.headlineSmall),
              const SizedBox(height: 8),
              if (sections.isEmpty)
                Text(l10n.grave_biography_empty, style: mutedStyle)
              else
                for (final (index, section) in sections.indexed) ...[
                  if (index > 0) const SizedBox(height: 16),
                  section,
                ],
            ],
          ),
        ),
      ),
    );
  }
}

String? _nonBlank(String? value) => value == null || value.trim().isEmpty ? null : value.trim();

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.labelMedium?.copyWith(color: context.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        child,
      ],
    );
  }
}
