import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/widgets/square_avatar.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required this.idPlayer});
  final int idPlayer;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
 List<Gameplayer> _favoritesGame = [];
 final PlayerService _playerService = PlayerService();
   @override
  void initState()  {
    super.initState();
       _playerService.getAllGiochiPreferiti(widget.idPlayer).then((onValue){
       setState(() {
         _favoritesGame = onValue;
       });
      
    });
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
                      "Preferiti",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, fontFamily: 'Inter')
                  )
                ),
              ],
            ),
              const Divider(),

              (_favoritesGame.isEmpty) ?

                const Expanded(
                    child: Center(
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
            :  Expanded(child: 
            ListView.separated(
        itemCount: _favoritesGame.length,
        separatorBuilder: (context, index) => const Divider(), 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_favoritesGame[index].game!.nome!, style: const TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
            subtitle:  Text(_favoritesGame[index].game!.sviluppatore!, style: const TextStyle(fontFamily: 'Inter')),
            leading:  SquareAvatar(imageUrl: _favoritesGame[index].game!.immagineURL!, size: 50 ),
            trailing: IconButton(
          icon: Icon(
            _favoritesGame[index].preferito! ? Icons.star : Icons.star_border,
            color:  _favoritesGame[index].preferito! ? Colors.yellow : Colors.grey,
            size: 25.0,
          ),
          onPressed: () {
            setState((){
              _favoritesGame[index].preferito = !_favoritesGame[index].preferito!;
              _playerService.setPreferito(_favoritesGame[index].id!, widget.idPlayer, _favoritesGame[index].preferito!);
              _favoritesGame.remove(_favoritesGame[index]);
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
    );
  }
  
}