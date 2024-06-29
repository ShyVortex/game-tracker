import 'dart:async';
import 'dart:convert';

import 'package:game_tracker/utilities/Utilities.dart';
import 'package:http/http.dart ' as http;

import '../models/player.dart';
class Playerservice {
    final String playerURL = 'http://localhost:8080/api/game-manager/player/';

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

    Future<Player?>? addPlayer(Player player) async {

      Uri uri = Uri.parse('${playerURL}addPlayer');

      return await  Future(() {
        Utilities.hashPassword(player.password!).then((value) async {
          player.password = value;
          var jsonObject = jsonEncode(player);
            http.post(uri,body: jsonObject, headers: headers).then((response){
                if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);

      }
      else {
        print("C'è stato un errore nella chiamata");
      }
      });
          });
      
  });

      


    }
}