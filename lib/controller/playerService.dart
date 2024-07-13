import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/gamePlayer.dart';
import 'package:game_tracker/pages/profile/profile_page.dart';
import 'package:game_tracker/utilities/login_utilities.dart';
import 'package:http/http.dart' as http;

import '../models/game.dart';
import '../models/player.dart';

class PlayerService {
  final String playerURL =
      'https://gamemanager-backend.onrender.com/api/game-manager/player/';

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future addPlayer(Player player) async {
    Uri uri = Uri.parse('${playerURL}addPlayer');

    return Future.delayed(const Duration(seconds: 3), () async {
      player.password = await LoginUtilities.hashPassword(player.password!);
      var jsonObject = jsonEncode(player);
      http.Response response =
          await http.post(uri, body: jsonObject, headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return Player.fromJson(data);
      } else {
        print("C'è stato un errore nella chiamata");
        return null;
      }
    });
  }

  Future getPlayerByEmail(String email) async {
    Uri uri = Uri.parse('${playerURL}getPlayerByEmail/$email');

    http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      throw Error();
    }
  }

  Future getAllGiochiPosseduti(int id) async {
    Uri uri = Uri.parse('${playerURL}getGiochiPosseduti/$id');

    http.Response response = await http.get(uri, headers: headers);
    List<GamePlayer> games = [];
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      games = data.map((json) => GamePlayer.fromJson(json)).toList();

      return games;
    } else {
      throw Error();
    }
  }

  Future getAllGiochiPreferiti(int id) async {
    Uri uri = Uri.parse('${playerURL}getGiochiPreferiti/$id');

    http.Response response = await http.get(uri, headers: headers);
    List<GamePlayer> games = [];
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      games = data.map((json) => GamePlayer.fromJson(json)).toList();

      return games;
    } else {
      throw Error();
    }
  }

  Future setPreferito(int idGame, int idPlayer, bool preferito) async {
    Uri uri =
        Uri.parse('${playerURL}setPreferito/$idGame/$idPlayer/$preferito');

    http.Response response = await http.put(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return GamePlayer.fromJson(data);
    } else {
      throw Error();
    }
  }

  Future updatePlayer(Player player, int idPlayer) async {
    final Player old = ProfilePage.comparison;

    Uri uri =
        Uri.parse('${playerURL}updatePlayer/$idPlayer');

    return Future.delayed(const Duration(seconds: 1), () async {

      if (player.password != old.password) {
        player.password = await LoginUtilities.hashPassword(player.password!);
      }

      var jsonObject = jsonEncode(player);
      http.Response response =
      await http.put(uri, body: jsonObject, headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data);
        return Player.fromJson(data);
      } else {
        print("C'è stato un errore nella chiamata");
        return null;
      }
    });
  }

  Future addGiocoPreferito(Player player, Game game) async {
    int idPlayer = player.id!;
    int idGame = game.id!;

    Uri uri =
    Uri.parse('${playerURL}addPreferito/$idPlayer/$idGame');

    var jsonObject = jsonEncode(player);

    http.Response response = await http.post(uri,
        body: jsonObject, headers: headers
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      print("C'è stato un errore nella chiamata");
      return null;
    }
  }

  Future removeGiocoPreferito(Player player) async {
    int idPlayer = player.id!;

    Uri uri =
    Uri.parse('${playerURL}removePreferito/$idPlayer');

    var jsonObject = jsonEncode(player);

    http.Response response = await http.delete(uri,
        body: jsonObject, headers: headers
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      print("C'è stato un errore nella chiamata");
      return null;
    }
  }
}
