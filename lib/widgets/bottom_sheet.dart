import "package:flutter/material.dart";

import "../theme/colors.dart";

class MyDraggableSheet extends StatefulWidget {
  const MyDraggableSheet({super.key});

  @override
  State<MyDraggableSheet> createState() => _MyDraggableSheetState();
}

class _MyDraggableSheetState extends State<MyDraggableSheet> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  Future<void> _animateSheet(double size) async {
    await _controller.animateTo(size, duration: const Duration(milliseconds: 50), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet => _sheet.currentWidget! as DraggableScrollableSheet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minSize = 200 / constraints.maxHeight;

        return DraggableScrollableSheet(
          key: _sheet,
          minChildSize: minSize,
          snap: true,
          snapSizes: [minSize, 0.5],
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return DefaultTabController(
              length: 2,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: ColorsConsts.surface,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  child: Stack(
                    children: [
                      CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 29)),
                          SliverPadding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            sliver: SliverList.list(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text("Imię i nazwisko", style: Theme.of(context).textTheme.headlineMedium),
                                    ),
                                    const SizedBox(width: 16),
                                    const CircleAvatar(
                                      radius: 22,
                                      backgroundColor: ColorsConsts.card,
                                      child: Icon(
                                        Icons.person_outline,
                                        color: ColorsConsts.accent,
                                        semanticLabel: "Profile",
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Text("XX.XX.XXXX - XX.XX.XXXX", style: Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.navigation, semanticLabel: "Odznacz grób jako odwiedzony"),
                                      label: const Text("Odznacz jako odwiedzony"),
                                    ),
                                    const SizedBox(width: 12),
                                    FilledButton.tonalIcon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.directions, semanticLabel: "Nawiguj do celu"),
                                      label: const Text("Nawigacja"),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                SizedBox(
                                  height: 300,
                                  child: CarouselView(
                                    itemExtent: 280,
                                    shrinkExtent: 200,
                                    children: [
                                      for (int i = 0; i < 3; i++)
                                        // ignore: solvro_config/asset_image
                                        Image.asset(
                                          "assets/images/grave.jpg",
                                          fit: BoxFit.cover,
                                          semanticLabel:
                                              "Zdjęcie grobu numer ${i + 1}",
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                DetailsSection(),

                                const SizedBox(height: 8),

                                Center(
                                  child: TextButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      semanticLabel: "Zgłoś poprawkę dotyczącą informacji o grobie",
                                    ),
                                    label: const Text("Zgłoś poprawkę"),
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            height: 29,
                            color: ColorsConsts.surface,
                            child: Center(
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: ColorsConsts.accent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(
                        4,
                        (index) => BiographyCard(
                          "199$index",
                          "Osiągnięcie",
                          "Opis osiągnięcia profesora",
                          key: ValueKey(index),
                        ),
                      ),
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

class BiographyCard extends StatelessWidget {
  final String date;
  final String event;
  final String description;

  const BiographyCard(this.date, this.event, this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("$date: $event", style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(description, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
