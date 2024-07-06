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
        print(data);

        games = data.map((json) => Game.fromJson(json)).toList();
       
        return games;
      }
      else {
        throw Error();
      }
    }
}