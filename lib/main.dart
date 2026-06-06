import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_grobownik/palette.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        fontFamily: GoogleFonts.roboto().fontFamily,
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24.0,          
            fontWeight: FontWeight.bold, 
            letterSpacing: 0.15, 
            fontFamily: GoogleFonts.robotoSlab().fontFamily,
          ),
          headlineSmall: TextStyle(
            fontSize: 18.0,          
            fontWeight: FontWeight.bold, 
            fontFamily: GoogleFonts.robotoSlab().fontFamily,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0            
          ),
          bodyLarge: TextStyle(
            fontSize: 20.0
          )
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Palette.inkBlack
        ),
        colorScheme: .fromSeed(
          seedColor: Palette.inkBlack,
        brightness: Brightness.dark),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You have pushed the button this many times:'),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const MyDraggableSheet(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          unawaited(HapticFeedback.selectionClick());
          _incrementCounter();
        },
        tooltip: "Increment",
        child: const Icon(Icons.add, semanticLabel: "Increment counter"),
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
          snapSizes: [
            60 / constraints.maxHeight,
            0.5,
          ],
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
                        
                        Image.asset('assets/images/grave.jpg', width: 300.0, height: 300.0,),

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
                                          color: Palette.charcoalBlue, 
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
                                } 
                                
                                else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Column(
                                      children: List.generate(4, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12.0),
                                          child: Card(
                                            color: Palette.charcoalBlue,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
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
                                                          " ${1900 + (index*10)}: Osiągnięcie",
                                                          style: Theme.of(context).textTheme.headlineSmall,
                                                        ),
                                                        const SizedBox(height: 4),
                                                        const Text(
                                                          'Tutaj znajduje się dłuższy opis konkretnego wydarzenia z życiorysu, który automatycznie zawija się do nowej linii.',
                                                          style: TextStyle(color: Colors.white70),
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