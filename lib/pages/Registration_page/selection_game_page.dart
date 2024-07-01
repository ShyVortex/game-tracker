import 'package:flutter/material.dart';
import 'package:game_tracker/controller/gamePlayerService.dart';
import 'package:game_tracker/controller/gameService.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/widgets/app_logo.dart';
import 'package:game_tracker/widgets/loading_Screen.dart';

class SelectionGamePage extends StatefulWidget {
final String? data;

const SelectionGamePage({super.key, required this.data });
  


  @override
  _SelectionGamePage createState() => _SelectionGamePage();
}

class _SelectionGamePage extends State<SelectionGamePage> {
   bool isLoading = true;
   List<Game> _games = [];
   final Gameservice _gameservice = Gameservice();
   final GamePlayerservice _gamePlayerservice = GamePlayerservice();

     Future<List<Game>?> fetchData() async {
    _games = await _gameservice.getAll();
    setState(() {
    isLoading = false;
    });
     }
      @override
    void initState() {
    super.initState();
    fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: const AppLogo(),
      ),
      body: isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) :
       Column(children: [
        const Text(
  "QUALI DI QUESTI GIOCHI POSSIEDI?",
  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  textAlign: TextAlign.center, // Allineamento del testo al centro
  maxLines: 2, // Numero massimo di righe
  overflow: TextOverflow.ellipsis, // Troncamento con ellissi se il testo supera le 2 righe
),
SizedBox(
  height: 430,
  child: 
       ListView.separated(
        itemCount: _games.length,
        separatorBuilder: (context, index) => Divider(), 
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_games[index].nome!),
            subtitle:  Text(_games[index].sviluppatore!),
            leading:  CircleAvatar(
              backgroundImage: NetworkImage(_games[index].immagineURL!),
            ),
            trailing: Checkbox(
              value: _games[index].isSelected,
              onChanged: (bool? value) {
                setState(() {
                  _games[index].isSelected = value ?? false;
                });
              },
            ),
            
            onTap: () {
              setState(() {
                _games[index].isSelected = !_games[index].isSelected!;
              });
            },
          );
        },
      )
      ),
       const SizedBox(height:30),
       FilledButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => LoadingScreen( httpOperation: _gamePlayerservice.performSelection(widget.data, _games)!,widget: const Placeholder(),  )));
                    },
                    child: const Text("CONFERMA"),
                  ),
    ]
       )
    );
    
  }
  }
  
  