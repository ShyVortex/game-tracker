import 'dart:async';
import 'dart:convert';

import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:game_tracker/utilities/reference_utilities.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/player.dart';
class PlayerService {
    final String playerURL = 'https://gamemanager-backend.onrender.com/api/game-manager/player/';
    

    final  headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

    Future addPlayer(Player player) async {
      Uri uri = Uri.parse('${playerURL}addPlayer');
        
      player.password = await LoginUtilities.hashPassword(player.password!);
      var jsonObject = jsonEncode(player);
      http.Response response = await http.post(uri,body: jsonObject, headers: headers);
        if(response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        ReferenceUtilities.setActivePlayer(player);
        return Player.fromJson(data);
      }
      else {
        print("C'è stato un errore nella chiamata");
        return null;
      }

      
  

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

      final prefs = await SharedPreferences.getInstance();


      http.Response response = await http.get(uri,headers:headers);
      List<GamePlayer> games = [];
      if(response.statusCode == 200){

        prefs.setString('gamesPosseduti',response.body);
        List<dynamic> data = jsonDecode(response.body);
        
        

        games = data.map((json) => GamePlayer.fromJson(json)).toList();
        
       
        return games;
      }
      else {
        throw Exception();
        
      }

    }
  Future getAllGiochiPreferiti(int id) async {
     Uri uri = Uri.parse('${playerURL}getGiochiPreferiti/$id');

     final prefs = await SharedPreferences.getInstance();

      http.Response response = await http.get(uri,headers:headers);
      List<GamePlayer> games = [];
      if(response.statusCode == 200){

        prefs.setString('gamesPreferiti',response.body);
        List<dynamic> data = jsonDecode(response.body);
        

        games = data.map((json) => GamePlayer.fromJson(json)).toList();
        
       
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
         return  GamePlayer.fromJson(data);
      }
      else {
        throw Error();
      }
  }
}