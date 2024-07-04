import 'package:flutter/material.dart';
import 'package:game_tracker/pages/library/add_game_page.dart';
import 'package:game_tracker/theme/app_theme.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/widgets/square_avatar.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.idPlayer});
  final int idPlayer;

  @override
  State<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  int navigationIndex = 0;
  List<Gameplayer> _games = [];
  PlayerService _playerService = PlayerService();
  ThemeData themeData = AppTheme.buildThemeData();

  @override
  void initState()  {
    super.initState();
       _playerService.getAllGiochiPosseduti(widget.idPlayer).then((onValue){
       setState(() {
         _games = onValue;
       });

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

              (_games.isEmpty) ?
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
                ))
            :  Expanded(child:
            ListView.separated(
        itemCount: _games.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_games[index].game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            subtitle:  Text(_games[index].game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
            leading:  SquareAvatar(imageUrl: _games[index].game!.immagineURL!, size: 50 ),
            trailing: IconButton(
          icon: Icon(
            _games[index].preferito! ? Icons.star : Icons.star_border,
            color:  _games[index].preferito! ? Colors.yellow : Colors.grey,
            size: 25.0,
          ),
          onPressed: () {
            setState(() {
              _games[index].preferito = !_games[index].preferito!;
              _playerService.setPreferito(_games[index].id!,widget.idPlayer,_games[index].preferito!);
            });
          },
        ),
          );
        },
      )
       ),
            ]
            )
            ),
          floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: Colors.purple,
          onPressed: onAddPress,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: themeData.dividerColor.withOpacity(0.12),
                width: 2.0,
              ),
            ),
          ),
          child: BottomNavigationBar(
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
        )
    );
  }
}