import "package:flutter/material.dart";

import "../../../../app/l10n/app_localizations.dart";
import "../../data/models/grave.dart";
import "biography_card.dart";
import "grave_location_card.dart";
import "grave_notes_card.dart";

class DetailsSection extends StatelessWidget {
  const DetailsSection({required this.grave, super.key});

  final Grave grave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: l10n.grave_tab_directions),
            Tab(text: l10n.grave_tab_biography),
          ],
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                return switch (tabController.index) {
                  0 => Column(
                    children: [
                      GraveLocationCard(grave: grave),
                      const SizedBox(height: 8),
                      GraveNotesCard(grave: grave),
                    ],
                  ),
                  _ => BiographyCard(grave: grave),
                };
              },
            );
          },
        ),
      ],
    );
  }
}
