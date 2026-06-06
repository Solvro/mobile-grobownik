//WERSJA 1 - Lepsza :)

/*PALETA KOLORÓW – GROBOWNIK UI

TŁO APLIKACJI (BACKGROUND)
#001626
TŁO MAPY
#001626
PANEL DOLNY
#001F33
AKCENT 
#FFD358
KARTY / ELEMENTY LISTY
#002E4D
OBRAMOWANIE KART
#083A5C
TŁO AVATARÓW / IKON
#002E4D
TEKST GŁÓWNY
#FFFFFF
TEKST W KARTACH
#FFFFFF
TEKST POMOCNICZY (PLACEHOLDER MAPY)
#A9C2D8
*/

import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFF001626), // было 011B2F
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF001626),
            child: const Center(
              child: Text(
                'MAP PLACEHOLDER',
                style: TextStyle(
                  color: Color(0xFFA9C2D8),
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
                  color: Color(0xFF001F33), // было 002A45
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
                        color: const Color(0xFFFFD358),
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
                            backgroundColor: Color(0xFF002E4D), // темнее
                            child: Icon(
                              Icons.person_outline,
                              color: Color(0xFFFFD358),
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
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Color(0xFF002E4D), // темнее
                            child: Icon(
                              Icons.add,
                              color: Color(0xFFFFD358),
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
                                color: const Color(0xFF002E4D), // было 003F66
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFF083A5C), // темнее граница
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
                                      color: Colors.white,
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

//WERSJA 2 - świetła, mi się nie podoba, ale zostawiam dla porównania :(

// Kolorów nie będzie :}

/*import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF0F2F5), // холодный серый фон
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFE3E7ED), // карта (стальной серый)
            child: const Center(
              child: Text(
                'MAP PLACEHOLDER',
                style: TextStyle(
                  color: Color(0xFF6B7280),
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
                  color: Color(0xFFFFFFFF), // панель белая
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
                        color: const Color(0xFF1F6FEB), // акцент синий
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
                            backgroundColor: Color(0xFFE9EDF2),
                            child: Icon(
                              Icons.person_outline,
                              color: Color(0xFF1F6FEB),
                            ),
                          ),

                          const Expanded(
                            child: Center(
                              child: Text(
                                'GROBOWNIK',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 2,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                          ),

                          const CircleAvatar(
                            radius: 22,
                            backgroundColor: Color(0xFFE9EDF2),
                            child: Icon(
                              Icons.add,
                              color: Color(0xFF1F6FEB),
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
                                color: const Color(0xFFF8FAFC), // карточки
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(0xFFD0D7E2),
                                  width: 1.5,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    graves[index],
                                    style: const TextStyle(
                                      color: Color(0xFF475569),
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
}*/