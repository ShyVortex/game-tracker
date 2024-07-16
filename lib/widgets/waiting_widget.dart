
import 'package:flutter/material.dart';
import 'package:game_tracker/widgets/app_logo.dart';

class WaitingWidget extends StatelessWidget{
  const WaitingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
      padding: EdgeInsets.only(top: 32),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text("Game Tracker",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                fontFamily: 'Inter')),
        SizedBox(height: 24),
        AppLogo(),
        SizedBox(height: 40),
        Center(
          child: CircularProgressIndicator(),
        )
      ]
      )
      )
      )
      )
      );
  }
    
}