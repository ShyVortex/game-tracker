import 'package:flutter/material.dart';
import 'package:game_tracker/controller/playerService.dart';
import 'package:game_tracker/models/player.dart';

class RegistrationLoadingScreen extends StatelessWidget{
  final Player player;
  final Playerservice _playerservice = Playerservice();

   RegistrationLoadingScreen({super.key, required this.player});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Registrazione avvenuta")),
      body: 
      FutureBuilder(
        future: _playerservice.addPlayer(player),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Placeholder();
          }
        },
      ),
    );
  }

}