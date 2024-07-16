import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/pages/library/add_game_page.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/pages/library/edit_game_page.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/widgets/square_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/player.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key, required this.player});
  final Player player;

  @override
  State<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage> {
  List<GamePlayer> _games = [];
  final PlayerService _playerService = PlayerService();
  bool _isLoading = true;
  List<GamePlayer> searchResults = [];
  final TextEditingController searchController = TextEditingController();

  final int settingsIndex = 3;

  void fetchData(){
      _playerService.getAllGiochiPosseduti(widget.player.id!).then((onValue){
       setState(() {
         _games = onValue;
         searchResults = _games;
         _isLoading = false;
       });
         }).catchError((onError) async {
        final prefs = await SharedPreferences.getInstance();
        List<dynamic> data = jsonDecode(prefs.getString("gamesPosseduti")!);
        _games = data.map((json) => GamePlayer.fromJson(json)).toList();
        searchResults = _games;

        setState(() {
         _isLoading = false;
       });
         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impossibile connettersi al server. Alcune funzioni potrebbero essere limitate')));
         });
  }
  Future<void> searchGame() async {
    setState(() {
      _isLoading = true;
    });

    final searchResult = _games.where(
        (result) => result.game!.nome!.toLowerCase()
            .contains(searchController.text.toLowerCase())).toList(
    );

    setState(() {
      searchResults = searchResult;
      _isLoading = false;
    });
  }


  @override
  void initState()  {
    super.initState();
    fetchData();

  }

  void routeToSettings() {
    Navigator.push(context,
        MaterialPageRoute(builder:
            (context) => NavigationState.setCurrentPage(settingsIndex))
    );
  }

  void onAddPress() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddGamePage())
    );
  }

  Future<void> potentialUpdatePlayer(GamePlayer gamePlayer, WidgetRef ref) async {
    if (gamePlayer.game?.nome == widget.player.giocoPreferito) {
      Player updated = widget.player;
      updated.giocoPreferito = "";
      await _playerService.updatePlayer(widget.player, widget.player.id!);

      setState(() {
        ref.read(playerProvider.notifier)
            .update((state) => updated);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    SafeArea(
        child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: routeToSettings,
                            icon: Icon(
                                Icons.settings,
                                size: 28,
                                color: GameTracker.isLightOrDark(context) == "Light" ?
                                    Colors.black : Colors.grey[100]
                            )
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
                    Expanded(
                        child: _isLoading ?
                        const Center(child:
                        CircularProgressIndicator.adaptive()):const Center(
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
                        :  _isLoading ?
                    const Center(child:
                    CircularProgressIndicator.adaptive()):
                     Column(children: [
                      const SizedBox(height:10),
                      SizedBox(height: 50,width: 325,
                        child:
                        TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                hintText: 'Cerca gioco...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                  color: GameTracker.isLightOrDark(context) == "Light"
                    ? Colors.grey[700]
                      : Colors.grey[400]
                ),
                prefixIcon: Icon(
                    Icons.search,
                    color: GameTracker.isLightOrDark(context) == "Light"
                        ? Colors.grey[700]
                        : Colors.grey[400]
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: GameTracker.isLightOrDark(context) == "Light"
                    ? const Color.fromARGB(155, 22, 18, 18)
                    : Colors.white,
                    width: 0.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
              ),
                        onChanged: (value) => searchGame()
                        )
                        ),
                    const SizedBox(height: 10),
                    // 232px è la dimensione degli altri widget
                    SizedBox(height: MediaQuery.sizeOf(context).height - 232,
                    child:
                    ListView.separated(
                      itemCount: searchResults.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => EditGamePage(gameplayer: searchResults[index], player: widget.player))
                            );
                          },
                          title: Text(searchResults[index].game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                          subtitle:  Text(searchResults[index].game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
                          leading:  SquareAvatar(imageUrl: searchResults[index].game!.immagineURL!, size: 50 ,isNetworkImage: searchResults[index].game!.isNetworkImage!,isTouchable: false,),
                          trailing: Consumer(builder: (context, ref, child) {
                            return IconButton(
                              icon: Icon(
                                searchResults[index].preferito! ? Icons.star : Icons.star_border,
                                color:  searchResults[index].preferito! ? Colors.yellow : Colors.grey,
                                size: 25.0,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchResults[index].preferito = !searchResults[index].preferito!;
                                  _playerService.setPreferito(searchResults[index].id!,widget.player.id!,searchResults[index].preferito!);
                                  if (searchResults[index].preferito == false) {
                                    potentialUpdatePlayer(searchResults[index], ref);
                                  }
                                });
                              },
                            );
                          }),
                    );
                      },
                    )
                    )
                  ])

                  ]
              )
          ),
          floatingActionButton:
          !_isLoading ?
          FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.purple,
            onPressed: onAddPress,
            child: Icon(Icons.add, color: Colors.grey[100], size: 30),
          )
              : null
        )
    );
  }
}