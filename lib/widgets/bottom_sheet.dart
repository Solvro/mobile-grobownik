import 'package:flutter/material.dart';
import 'package:mobile_grobownik/theme/colors.dart';

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

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          key: _sheet,
          initialChildSize: 0.5,
          maxChildSize: 1,
          minChildSize: 0,
          expand: true,
          snap: true,
          snapSizes: [60 / constraints.maxHeight, 0.5],
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            return DefaultTabController(
              length: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).bottomSheetTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Text(
                          'Imię i nazwisko',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      SliverList.list(
                        children: [
                          Text(
                            'XX.XX.XXXX - XX.XX.XXXX',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.navigation),
                                label: const Text('Odznacz jako odwiedzony'),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.tonalIcon(
                                onPressed: () {},
                                icon: const Icon(Icons.directions),
                                label: const Text('Nawigacja'),
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
                                Image.asset(
                                  'assets/images/grave.jpg',
                                  fit: BoxFit.cover,
                                ),
                                Image.asset(
                                  'assets/images/grave.jpg',
                                  fit: BoxFit.cover,
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
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Zgłoś poprawkę'),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
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
            Tab(text: 'Wzkazówki dojścia'),
            Tab(text: 'Życiorys'),
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
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Card(
                          color: ColorsConsts.charcoalBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Card(
        color: ColorsConsts.charcoalBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.timeline, color: Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$date: $event",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.white70),
                    ),
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
