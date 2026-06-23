import "package:flutter/material.dart";

import "../theme/app_theme.dart";
import "biography_card.dart";

class DetailsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(text: "Wzkazówki dojścia"),
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
                  return Column(
                    children: List.generate(
                      4,
                      (index) =>
                          BiographyCard("199$index", "Osiągnięcie", "Opis osiągnięcia profesora", key: ValueKey(index)),
                    ),
                  );
                }
              },
            );
          },
        ),
      ],
    );
  }
}
