import 'dart:convert';

import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/models/player.dart';
import 'package:http/http.dart' as http;

class GamePlayerservice {
    final String gamePlayerURL = 'http://localhost:8080/api/game-manager/gamePlayer/';
    final playerservice = PlayerService();

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
      gameplayer.preferito = false;
      gameplayer.trofeiTotali = 60;
      gameplayer.trofeiOttenuti = 0;
      gameplayer.oreDiGioco = 0;
      gameplayer.valutazione = 0;
      gameplayer.luogoCompletamento = "";
      await _addGameToPlayer(element.id,player.id!,gameplayer);
     });
     return "operazione eseguita";
    });
    
    
  }
}