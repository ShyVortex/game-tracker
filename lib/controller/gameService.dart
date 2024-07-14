import 'dart:convert';

import 'package:game_tracker/models/game.dart';
import 'package:http/http.dart' as http;

class Gameservice {
    final String gameURL = 'https://gamemanager-backend.onrender.com/api/game-manager/game/';

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future getAll() async {
      Uri uri = Uri.parse('${gameURL}getAll');

      http.Response response = await http.get(uri,headers:headers);
      List<Game> games =[];

       if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);

        games = data.map((json) => Game.fromJson(json)).toList();
        print(games);

        return games;
      }
      else {
        throw Error();
      }
    }
    Future addGame(Game game) async {

      Uri uri = Uri.parse('${gameURL}addGame');

      
        
      var jsonObject = jsonEncode(game);

      http.Response response = await http.post(uri,body: jsonObject, headers: headers);

        if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return Game.fromJson(data);
      }
      else if (response.statusCode == 404) {
          print("C'è stato un errore nella chiamata, "
              "\nCode: ${response.statusCode},"
              "\nBody:\n${response.body}"
          );
          return null;
      }
    }
}