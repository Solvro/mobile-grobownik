import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:google_fonts/google_fonts.dart';
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:mobile_grobownik/palette.dart';

import "theme/colors.dart";


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
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final graves = List.generate(8, (index) => 'Grave ${index + 1}');

    return Scaffold(
      backgroundColor: ColorsConsts.background,
      body: Stack(
        children: [
          Container(
            color: ColorsConsts.background,
            child: const Center(
              child: Text(
                'MAP PLACEHOLDER',
                style: TextStyle(
                  color: ColorsConsts.textSecondary,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.18,
            minChildSize: 0.12,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: ColorsConsts.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ColorsConsts.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: ColorsConsts.card,
                            child: Icon(
                              Icons.person_outline,
                              color: ColorsConsts.accent,
                            ),
                          ),

                          const Expanded(
                            child: Center(
                              child: Text(
                                'GROBOWNIK',
                                style: TextStyle(
                                  fontFamily: 'KONSTRUKT-Regular',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 4,
                                  color: ColorsConsts.textPrimary,
                                ),
                              ),
                            ),
                          ),

                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: ColorsConsts.card,
                            child: Icon(
                              Icons.add,
                              color: ColorsConsts.accent,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: graves.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                color: ColorsConsts.card,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: ColorsConsts.border,
                                  width: 2,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    graves[index],
                                    style: const TextStyle(
                                      color: ColorsConsts.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

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
                                    Image.asset('assets/images/grave.jpg', fit: BoxFit.cover),
                                    Image.asset('assets/images/grave.jpg', fit: BoxFit.cover),
                                  ],
                                ),
                              ),

                          const SizedBox(height: 16),

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
                              final tabController = DefaultTabController.of(
                                context,
                              );

                              return AnimatedBuilder(
                                animation: tabController,
                                builder: (context, child) {
                                  if (tabController.index == 0) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                          ),
                                          child: Card(
                                            color: Palette.charcoalBlue,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        children: List.generate(4, (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12.0,
                                            ),
                                            child: Card(
                                              color: Palette.charcoalBlue,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  16.0,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                      Icons.timeline,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 16),

                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            " ${1900 + (index * 10)}: Osiągnięcie",
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .headlineSmall,
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          const Text(
                                                            'Tutaj znajduje się dłuższy opis konkretnego wydarzenia z życiorysu, który automatycznie zawija się do nowej linii.',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),

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
