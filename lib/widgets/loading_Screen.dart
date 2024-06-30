import 'package:flutter/material.dart';
import 'package:game_tracker/models/player.dart';

class LoadingScreen extends StatelessWidget{
  final Player player;
  final Future httpOperation; 

   const LoadingScreen({super.key, required this.player, required this.httpOperation});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: 
      FutureBuilder(
        future: httpOperation.then((onValue){
          print("valore ottenuto");
        }),
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