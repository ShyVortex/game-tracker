import 'package:flutter/material.dart';
import 'package:game_tracker/models/player.dart';
import 'package:game_tracker/pages/Registration_page/selection_game_page.dart';

class LoadingScreen extends StatelessWidget{
  final Player player;
  final Future httpOperation; 

   const LoadingScreen({super.key, required this.player, required this.httpOperation});


  @override
  Widget build(BuildContext context) {
    return
      FutureBuilder(
        future: httpOperation,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SelectionGamePage();
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }

}