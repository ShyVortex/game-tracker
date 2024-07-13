import 'dart:async';
import 'dart:convert';

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
        print("C'è stato un errore nella chiamata, "
            "\nCode: ${response.statusCode},"
            "\nBody:\n${response.body}"
        );
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

  Future addPlayerBirthday(int idPlayer, String date) async {
    Uri uri =
        Uri.parse('${playerURL}addBirthday/$idPlayer');

    var jsonObject = jsonEncode({"dateString": date});

    http.Response response = await http.post(
      uri,
      body: jsonObject,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      print("C'è stato un errore nella chiamata, "
          "\nCode: ${response.statusCode},"
          "\nBody:\n${response.body}"
      );
      return null;
    }
  }

  Future updatePlayerBirthday(int idPlayer, String date) async {
    Uri uri =
        Uri.parse('${playerURL}updateBirthday/$idPlayer');

    var jsonObject = jsonEncode({"dateString": date});

    http.Response response = await http.put(
      uri,
      body: jsonObject,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      print("C'è stato un errore nella chiamata, "
          "\nCode: ${response.statusCode},"
          "\nBody:\n${response.body}"
      );
      return null;
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
        print("C'è stato un errore nella chiamata, "
            "\nCode: ${response.statusCode},"
            "\nBody:\n${response.body}"
        );
        return null;
      }
    });
  }

  Future addGiocoPreferito(Player player, Game game) async {
    int idPlayer = player.id!;
    int idGame = game.id!;

    Uri uri =
        Uri.parse('${playerURL}addPreferito/$idPlayer/$idGame');

    var jsonObject = jsonEncode(game);

    http.Response response = await http.post(uri,
        body: jsonObject, headers: headers
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data);
      return Player.fromJson(data);
    } else {
      throw Exception("C'è stato un errore nella chiamata, "
          "\nCode: ${response.statusCode},"
          "\nBody:\n${response.body}"
      );
    }
  }

  Future removeGiocoPreferito(int idPlayer) async {
    Uri uri =
        Uri.parse('${playerURL}removePreferito/$idPlayer');

    http.Response response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Chiamata effettuata corretamente");
    } else {
      print("C'è stato un errore nella chiamata, "
          "\nCode: ${response.statusCode},"
          "\nBody:\n${response.body}"
      );
    }
  }

  Future deletePlayer(int idPlayer) async {
    Uri uri =
        Uri.parse('${playerURL}deletePlayer/$idPlayer');

    http.Response response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      print("Chiamata effettuata corretamente");
    } else {
      print("C'è stato un errore nella chiamata, "
          "\nCode: ${response.statusCode},"
          "\nBody:\n${response.body}"
      );
    }
  }
}
