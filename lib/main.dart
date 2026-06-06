import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:google_fonts/google_fonts.dart';

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
    // Sprzątamy po sobie, gdy widget jest usuwany z ekranu
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
          snapSizes: [
            60 / constraints.maxHeight,
            0.5,
          ],
          controller: _controller,
          builder: (BuildContext context, ScrollController scrollController) {
            // Dodajemy DefaultTabController, aby pasek zakładek (TabBar) miał z czego czerpać stan
            return DefaultTabController(
              length: 2, // Mamy 4 zakładki
              child: DecoratedBox(
                decoration: BoxDecoration(
                  
                  color: Theme.of(context).bottomSheetTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Odsunięcie zawartości od krawędzi
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                     SliverToBoxAdapter(
                      child: Text('Imię i nazwisko',
                      style: Theme.of(context).textTheme.headlineMedium,)
                    ),
                    SliverList.list(
                      children: [
                         Text('XX.XX.XXXX - XX.XX.XXXX',
                         style: Theme.of(context).textTheme.bodyLarge,),
                        const SizedBox(height: 16), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                print('Kliknięto Start');
                              },
                              icon: const Icon(Icons.navigation),
                              label: const Text('Odznacz jako odwiedzony'),
                            ),
                            const SizedBox(width: 12), 
                            FilledButton.tonalIcon(
                              onPressed: () {
                                print('Kliknięto Directions');
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text('Nawigacja'),
                            ),                   
                            
                          ],
                        ),
                        const SizedBox(height: 16), 
                        
                        Image.asset('assets/images/grave.jpg', width: 300.0, height: 300.0,),

                        // ==========================================
                        // NOWY KOD
                        // ==========================================
                        const SizedBox(height: 16),

                        // 1. Rząd zakładek (TabBar)
                        const TabBar(
                          isScrollable: true, // Pozwala przewijać zakładki na boki
                          tabAlignment: TabAlignment.center, // Wyrównuje zakładki do lewej krawędzi, jak na zdjęciu
                          tabs: [
                            Tab(text: 'Wzkazówki dojścia'),
                            Tab(text: 'Życiorys'),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 2. Ciemnoniebieski obszar z tekstem (Card)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Card(
                            // Ręcznie ustawiony ciemny kolor na wzór tego ze zdjęcia
                            color: const Color(0xFF1A262C), 
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
              
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 3. Przycisk "Suggest an edit" (TextButton.icon)
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              print('Kliknięto Suggest an edit');
                            },
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Suggest an edit'),
                          ),
                        ),

                        const SizedBox(height: 32), // Bezpieczny margines na samym dole sheeta
                        // ==========================================
                        // KONIEC NOWEGO KODU
                        // ==========================================
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