import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/add_game_page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  int navigationIndex = 0;
  int addedGames = 0; // variabile placeholder

  void onItemTapped(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  void onAddPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddGamePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: null,
                      icon: Icon(Icons.settings, size: 28, color: Colors.black)
                  )
                ],
              ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 32),
                  child: Text(
                      "Libreria",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'Inter')
                  )
                ),
              ],
            ),
              const Divider(),

              if (addedGames == 0)
                const Expanded(
                    child: Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sembra che tu non abbia aggiunto ancora nessun gioco.",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text("Premi il pulsante + per aggiungerne uno!",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Inter'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )),
                )),

            ])),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.purple,
          onPressed: onAddPress,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              label: 'Libreria'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Preferiti',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profilo',
            ),
          ],
          currentIndex: navigationIndex,
          unselectedItemColor: Colors.black,
          unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600, fontFamily: 'Inter'
          ),
          selectedItemColor: Colors.purple,
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600, fontFamily: 'Inter'
          ),
          onTap: onItemTapped,
        )
    );
  }
}