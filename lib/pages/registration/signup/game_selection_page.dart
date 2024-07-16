import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_tracker/controller/gamePlayerService.dart';
import 'package:game_tracker/controller/gameService.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/main.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/navigationBar/navigation_page.dart';
import 'package:game_tracker/widgets/app_logo.dart';
import 'package:game_tracker/widgets/loading_screen.dart';

class GameSelectPage extends StatefulWidget {
  final String? data;

  const GameSelectPage({super.key, required this.data});

  @override
  GameSelectPageState createState() => GameSelectPageState();
}

class GameSelectPageState extends State<GameSelectPage> {
  bool isLoading = true;
  List<Game> _games = [];
  final List<Game> _networkGames = [];
  Player _player = Player();
  final PlayerService _playerService = PlayerService();
  final Gameservice _gameservice = Gameservice();
  final GamePlayerservice _gamePlayerservice = GamePlayerservice();

  Future<List<Game>?> fetchData() async {
    _games = await _gameservice.getAll();
    _player = await _playerService.getPlayerByEmail(widget.data!);
    return _games;
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((onValue) {
      for (var element in onValue!) {
        if (element.isNetworkImage!) {
          _networkGames.add(element);
        }
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  List<Game> _selectedGames() {
    List<Game> games = [];
    for (var element in _networkGames) {
      if (element.isSelected!) {
        games.add(element);
      }
    }
    return games;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              flexibleSpace: const AppLogo(width: 135, height: 101.8),
            ),
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                    const Text(
                      "Quali di questi giochi possiedi?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Inter'),
                      textAlign:
                          TextAlign.center, // Allineamento del testo al centro
                      maxLines: 2, // Numero massimo di righe
                      overflow: TextOverflow
                          .ellipsis, // Troncamento con ellissi se il testo supera le 2 righe
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    SizedBox(
                            height: 500,
                            child: ListView.separated(
                                itemCount: _networkGames.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_networkGames[index].nome!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Inter')),
                                    subtitle: Text(_networkGames[index].sviluppatore!,
                                        style: const TextStyle(
                                            fontFamily: 'Inter')),
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _networkGames[index].immagineURL!),
                                    ),
                                    trailing: Checkbox(
                                      value: _networkGames[index].isSelected,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _networkGames[index].isSelected =
                                              value ?? false;
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _networkGames[index].isSelected =
                                            !_networkGames[index].isSelected!;
                                      });
                                    },
                                  );
                                })
                                ),
                        
                    const SizedBox(height: 30),
                    Consumer(builder: (context, ref, child) {
                      return FilledButton(
                        onPressed: () {
                          ref.read(playerProvider.notifier).state = _player;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoadingScreen(
                                      httpOperation:
                                          _gamePlayerservice.performSelection(
                                              widget.data, _selectedGames())!,
                                      widget: const NavigationPage())));
                        },
                        child: const Text("CONFERMA",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Inter')),
                      );
                    })
                  ]))));
  }
}
