import 'dart:convert';

import 'package:game_tracker/controller/gameService.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/models/player.dart';
import 'package:http/http.dart' as http;

class GamePlayerservice {
    final String gamePlayerURL = 'https://gamemanager-backend.onrender.com/api/game-manager/gamePlayer/';
    final PlayerService playerService = PlayerService();
    final gameService = Gameservice();

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  Future _addGameToPlayer(int ? idGame, int idPlayer,GamePlayer gamePlayer) async {

     Uri uri = Uri.parse('${gamePlayerURL}addGameToPlayer/$idGame/$idPlayer');
     
     var jsonObject = jsonEncode(gamePlayer);
      http.Response response = await http.post(uri,body: jsonObject, headers: headers);
        if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return GamePlayer.fromJson(data);
      }
      else {
          print("C'è stato un errore nella chiamata, "
              "\nCode: ${response.statusCode},"
              "\nBody:\n${response.body}"
          );
        return null;
      }
  }
  Future? performSelection(String? email,List<Game> games) async {

    Player player = await playerService.getPlayerByEmail(email!);


      for (Game game in games){
      GamePlayer gameplayer = GamePlayer();
      await _addGameToPlayer(game.id,player.id!,gameplayer);
      }
     return "operazione eseguita";
    
    

  }

  Future performGameInsert(Game game,int idPlayer,GamePlayer gamePlayer) async {
    game = await gameService.addGame(game);
    return await _addGameToPlayer(game.id, idPlayer, gamePlayer);
  }
  Future updateGamePlayer(GamePlayer game, int id) async {

     Uri uri = Uri.parse('${gamePlayerURL}updateGamePlayer/$id');

     var jsonObject = jsonEncode(game);
      http.Response response = await http.put(uri,body: jsonObject, headers: headers);
        if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return GamePlayer.fromJson(data);
      } else {
          print("C'è stato un errore nella chiamata, "
              "\nCode: ${response.statusCode},"
              "\nBody:\n${response.body}"
          );
      }
  }
  Future deleteGamePlayer(int id) async {
     Uri uri = Uri.parse('${gamePlayerURL}deleteGamePlayer/$id');

     http.Response response = await http.delete(uri,headers: headers);
        if(response.statusCode == 200){
        print("Chiamata effettuata corretamente");

      } else {
          print("C'è stato un errore nella chiamata, "
              "\nCode: ${response.statusCode},"
              "\nBody:\n${response.body}"
          );
        }
  }
}