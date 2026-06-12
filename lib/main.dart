import 'package:flutter/material.dart';
import 'package:mobile_grobownik/theme/colors.dart';

void main() {
  runApp(const GrobownikApp());
}

class GrobownikApp extends StatelessWidget {
  const GrobownikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grobownik',
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