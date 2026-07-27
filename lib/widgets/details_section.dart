import "package:flutter/material.dart";

import "../theme/app_theme.dart";
import "biography_card.dart";

class DetailsSection extends StatelessWidget {
  final String biography; // <-- Передаем биографию из модели могилы

  const DetailsSection({required this.biography, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: "Wskazówki dojścia"), // Исправлено: "Wskazówki" вместо "Wzkazówki" :)
            Tab(text: "Życiorys"),
          ],
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);

            return AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                if (tabController.index == 0) {
                  return Card(
                    color: context.colorScheme.secondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ),
                  );
                } else {
                  // Отображаем полученную биографию в карточке
                  return BiographyCard("Życiorys", "Informacje", biography);
                }
              },
            );
          },
        ),
      ],
    );
  }
}
