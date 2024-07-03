import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class AddGamePage extends StatefulWidget {
  const AddGamePage({super.key});

  @override
  State<AddGamePage> createState() => AddGamePageState();
}

class AddGamePageState extends State<AddGamePage> {
  int navigationIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  void navigateBack() {
    Navigator.pop(context);
  }

  void onAddImage() {

  }

  void onConfirmPress() {

  }

  void onAddPlace() {

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            IconButton(onPressed: navigateBack, icon: const Icon(Icons.arrow_back)),
                            const Padding(padding: EdgeInsets.only(left: 10),
                              child: Text(
                                  "Aggiunta gioco",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'Inter')
                              )
                            )
                          ],
                        )
                    ),
                  ],
                ),
                const Divider(),
                Expanded(child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child:                   Column(
                      children: [
                        Row(
                          children: [
                            Card.outlined(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black.withOpacity(0.25),
                                    width: 2,
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: InkWell(
                                  splashColor: Colors.purple.withAlpha(30),
                                  onTap: onAddImage,
                                  child: const Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 16, left: 20, right: 20),
                                        child: Column(
                                          children: [
                                            Text("+",
                                                style: TextStyle(
                                                    fontSize: 50,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: 'Inter')),
                                            Text("Aggiungi\nimmagine",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Inter'))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(width: 24),
                            const SizedBox(
                                width: 170,
                                child: TextField(
                                    decoration: InputDecoration(
                                        border:  OutlineInputBorder(),
                                        labelText: "Nome",
                                        labelStyle: TextStyle(fontFamily: 'Inter')
                                    )
                                )
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Sviluppatore",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Piattaforma",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Ore di gioco",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Trofei ottenuti",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                const Text("Highlights", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Inter'
                                )),
                                Card.outlined(
                                  shape: CircleBorder(
                                    side: BorderSide(
                                      color: Colors.black.withOpacity(0.25),
                                      width: 2,
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    splashColor: Colors.purple.withAlpha(30),
                                    onTap: onAddImage,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 12, left: 12, right: 12),
                                      child: Text("+",
                                          style: TextStyle(
                                              fontSize: 72,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'Inter')),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Data completamento",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 300,
                          child: OutlinedButton.icon(
                              onPressed: onAddPlace,
                              icon: const Icon(Icons.location_on),
                              label: const Text("Dove hai completato il gioco?")
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(
                            width: 300,
                            child: TextField(
                                decoration: InputDecoration(
                                    border:  OutlineInputBorder(),
                                    labelText: "Valutazione",
                                    labelStyle: TextStyle(fontFamily: 'Inter')
                                )
                            )
                        ),
                        const SizedBox(height: 84)
                      ],
                    ),
                  )
                ))
            ]
        )
    ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.green,
          onPressed: onConfirmPress,
          child: const Icon(Icons.check, color: Colors.white, size: 30),
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