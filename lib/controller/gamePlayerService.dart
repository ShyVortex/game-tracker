import 'dart:convert';

import 'package:game_tracker/controller/gameService.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/models/player.dart';
import 'package:http/http.dart' as http;

class GamePlayerservice {
    final String gamePlayerURL = 'http://localhost:8080/api/game-manager/gamePlayer/';
    final playerservice = PlayerService();
    final gameService = Gameservice();

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Future _addGameToPlayer(int ? idGame, int idPlayer,Gameplayer gamePlayer) async {

     Uri uri = Uri.parse('${gamePlayerURL}addGameToPlayer/$idGame/$idPlayer');
     
     var jsonObject = jsonEncode(gamePlayer);
      http.Response response = await http.post(uri,body: jsonObject, headers: headers);
        if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return Gameplayer.fromJson(data);
      }
      else {
        print("C'è stato un errore nella chiamata");
        return null;
      }
  }
  Future? performSelection(String? email,List<Game> games) async {

    Player player = await playerservice.getPlayerByEmail(email!);

    return await  Future((){
      games.forEach((element) async {
      Gameplayer gameplayer = Gameplayer();
      await _addGameToPlayer(element.id,player.id!,gameplayer);
     });
     return "operazione eseguita";
    });
    
    
  }

  Future performGameInsert(Game game,int idPlayer,Gameplayer gamePlayer) async {
    game = await gameService.addGame(game);

    return await _addGameToPlayer(game.id, idPlayer, gamePlayer);
  }
}