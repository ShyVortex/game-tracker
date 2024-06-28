import 'dart:convert';

import 'package:http/http.dart ' as http;
class Playerservice {
    final String playerURL = 'http://localhost:8080/api/game-manager/player/';

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

    void addPlayer(Object player) async {
      Uri uri = Uri.parse('${playerURL}addPlayer');

      http.Response response = await http.post(uri,body: player, headers: headers);

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
      }
      else {
        print("C'è stato un errore nella chiamata");
      }


    }
}