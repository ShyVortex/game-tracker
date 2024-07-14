import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/widgets/square_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/player.dart';
import '../profile/profile_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required this.player});
  final Player player;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
 List<GamePlayer> _favoritesGame = [];
 bool _isLoading = true;
 final PlayerService _playerService = PlayerService();

 void fetchData(){
      _playerService.getAllGiochiPreferiti(widget.player.id!).then((onValue){
       setState(() {
         _favoritesGame = onValue;
         _isLoading = false;
       });
         }).catchError((onError) async {
        final prefs = await SharedPreferences.getInstance();
        List<dynamic> data = jsonDecode(prefs.getString("gamesPreferiti")!);
        _favoritesGame = data.map((json) => GamePlayer.fromJson(json)).toList();

        setState(() {
         _isLoading = false;
       });
         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impossibile connettersi al server. Alcune funzioni potrebbero essere limitate')));
         });
  }

   @override
  void initState() {
    super.initState();
    fetchData();
  }

 Future<void> potentialUpdatePlayer(GamePlayer gamePlayer, WidgetRef ref) async {
   if (gamePlayer.game?.nome == widget.player.giocoPreferito) {
     Player updated = widget.player;
     updated.giocoPreferito = "";
     await _playerService.updatePlayer(widget.player, widget.player.id!);

     setState(() {
       ref.read(playerProvider.notifier)
           .update((state) => updated);
       ProfilePage.comparison = widget.player;
     });
   }
 }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                                "Preferiti",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'Inter')
                            )
                        ),
                      ],
                    ),
                    const Divider(),

                    (_favoritesGame.isEmpty) ?

                 Expanded(
                    child: 
                     _isLoading ?
              const Center(child: 
               CircularProgressIndicator.adaptive()):const Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sembra che tu non abbia aggiunto ancora nessun gioco tra i preferiti.",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Inter'),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text("Aggiungine uno dalla libreria!",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'Inter'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )),
                ))
            :   _isLoading ?
              const Center(child: 
               CircularProgressIndicator.adaptive()):
               Expanded(child: 
            ListView.separated(
        itemCount: _favoritesGame.length,
        separatorBuilder: (context, index) => const Divider(), 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_favoritesGame[index].game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            subtitle:  Text(_favoritesGame[index].game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
            leading:  SquareAvatar(imageUrl: _favoritesGame[index].game!.immagineURL!, size: 50, isNetworkImage: _favoritesGame[index].game!.isNetworkImage!,isTouchable: false, ),
            trailing: Consumer(builder: (context, ref, child) {
              return IconButton(
                icon: Icon(
                  _favoritesGame[index].preferito! ? Icons.star : Icons.star_border,
                  color:  _favoritesGame[index].preferito! ? Colors.yellow : Colors.grey,
                  size: 25.0,
                ),
                onPressed: () {
                  setState((){
                    _favoritesGame[index].preferito = !_favoritesGame[index].preferito!;
                    _playerService.setPreferito(_favoritesGame[index].id!, widget.player.id!, _favoritesGame[index].preferito!);
                    if (_favoritesGame[index].preferito == false) {
                      potentialUpdatePlayer(_favoritesGame[index], ref);
                    }
                    _favoritesGame.remove(_favoritesGame[index]);
                  });
                },
              );
            }),
          );
        },
      )
       ),
            ]
            )
            ),
        )
    );
  }
}