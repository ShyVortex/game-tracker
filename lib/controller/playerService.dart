import 'dart:async';
import 'dart:convert';

import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/utilities/Utilities.dart';
import 'package:http/http.dart' as http;

import '../models/player.dart';
class PlayerService {
    final String playerURL = 'https://gamemanager-backend.onrender.com/api/game-manager/player/';

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

    Future addPlayer(Player player) async {
      Uri uri = Uri.parse('${playerURL}addPlayer');

      
      return Future.delayed(const Duration(seconds: 3), () async {
        
      player.password = await Utilities.hashPassword(player.password!);
      var jsonObject = jsonEncode(player);
      http.Response response = await http.post(uri,body: jsonObject, headers: headers);
        if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return Player.fromJson(data);
      }
      else {
        print("C'è stato un errore nella chiamata");
        return null;
      }
    });

      
  

    }
    Future getPlayerByEmail(String email) async {
      Uri uri = Uri.parse('${playerURL}getPlayerByEmail/$email');

      http.Response response = await http.get(uri,headers:headers);

       if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        print(data);
        return Player.fromJson(data);
      }
      else {
        throw Error();
      }
    }
    Future getAllGiochiPosseduti(int id) async {
      Uri uri = Uri.parse('${playerURL}getGiochiPosseduti/$id');

      http.Response response = await http.get(uri,headers:headers);
      List<Gameplayer> games = [];
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        

        games = data.map((json) => Gameplayer.fromJson(json)).toList();
        
       
        return games;
      }
      else {
        throw Error();
      }

    }
  Future getAllGiochiPreferiti(int id) async {
     Uri uri = Uri.parse('${playerURL}getGiochiPreferiti/$id');

      http.Response response = await http.get(uri,headers:headers);
      List<Gameplayer> games = [];
      if(response.statusCode == 200){
        List<dynamic> data = jsonDecode(response.body);
        

        games = data.map((json) => Gameplayer.fromJson(json)).toList();
        
       
        return games;
      }
      else {
        throw Error();
      }
  }
  Future setPreferito(int idGame, int idPlayer,bool preferito) async {
    Uri uri = Uri.parse('${playerURL}setPreferito/$idGame/$idPlayer/$preferito');

    http.Response response = await http.put(uri,headers:headers);

    if(response.statusCode == 200){
         var data = jsonDecode(response.body);
         return  Gameplayer.fromJson(data);
      }
      else {
        throw Error();
      }
  }
}